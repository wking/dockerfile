#!/bin/sh
#
# Copyright (C) 2013-2014 W. Trevor King <wking@tremily.us>
# Copyright (C) 2014 Naohiro Aota <naota@gentoo.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

AUTHOR="${AUTHOR:-W. Trevor King <wking@tremily.us>}"
NAMESPACE="${NAMESPACE:-$(id -u -n)}"
DATE="${DATE:-20160804}"
MIRROR="${MIRROR:-http://distfiles.gentoo.org/}"
ARCH_URL="${ARCH_URL:-${MIRROR}releases/amd64/autobuilds/${DATE}/}"
STAGE3="${STAGE3:-stage3-amd64-${DATE}.tar.bz2}"
STAGE3_CONTENTS="${STAGE3_CONTENTS:-${STAGE3}.CONTENTS}"
STAGE3_DIGESTS="${STAGE3_DIGESTS:-${STAGE3}.DIGESTS.asc}"
PORTAGE_URL="${PORTAGE_URL:-${MIRROR}snapshots/}"
PORTAGE="${PORTAGE:-portage-${DATE}.tar.xz}"
PORTAGE_SIG="${PORTAGE_SIG:-${PORTAGE}.gpgsig}"

DOCKER_IO=$(command -v docker.io)
DOCKER="${DOCKER:-${DOCKER_IO:-docker}}"
BUILD_OPTS="${BUILD_OPTS:-}"

REPOS="${REPOS:-
	portage
	gentoo-portage
	gentoo-python
	gentoo-utc
	gentoo-en-us
	gentoo-openrc
	gentoo-syslog
	gentoo-java
	gentoo-layman
	gentoo-node
	buildbot
	docker-registry
	elasticsearch
	hubot
	irker
	memcached
	nagios
	nginx
	nginx-proxy
	kibana
	kibana-azure
	ngircd
	package-cache
	postgresql
	redis
	salt
	salt-master
	salt-minion
	stunnel
	thumbor
	}"

die()
{
	echo "$1"
	exit 1
}

msg()
{
	echo "$@"
}

REALPATH="${REALPATH:-$(command -v realpath)}"
if [ -z "${REALPATH}" ]; then
	READLINK="${READLINK:-$(command -v readlink)}"
	if [ -n "${READLINK}" ]; then
		REALPATH="${READLINK} -f"
	else
		die "need realpath or readlink to canonicalize paths"
	fi
fi

# Does "${NAMESPACE}/${REPO}:${DATE}" exist?
# Returns 0 (exists) or 1 (missing).
#
# Arguments:
#
# 1: REPO
repo_exists()
{
	REPO="${1}"
	IMAGES=$("${DOCKER}" images "${NAMESPACE}/${REPO}")
	MATCHES=$(echo "${IMAGES}" | grep "${DATE}")
	if [ -z "${MATCHES}" ]; then
		return 1
	fi
	return 0
}

# If they don't already exist:
#
# * download the stage3 and
# * create "${NAMESPACE}/gentoo:${DATE}"
#
# Forcibly tag "${NAMESPACE}/gentoo:${DATE}" with "latest"
import_stage3()
{
	msg "import stage3"
	if ! repo_exists gentoo; then
		# import stage3 image from Gentoo mirrors

		for FILE in "${STAGE3}" "${STAGE3_CONTENTS}" "${STAGE3_DIGESTS}"; do
			if [ ! -f "downloads/${FILE}" ]; then
				wget -O "downloads/${FILE}" "${ARCH_URL}${FILE}" ||
					die "failed to download ${ARCH_URL}${FILE}"
			fi
		done

		gpg --verify "downloads/${STAGE3_DIGESTS}" ||
			die "insecure digests for gentoo"
		SHA512_HASHES=$(grep -A1 SHA512 "downloads/${STAGE3_DIGESTS}" | grep -v '^--')
		SHA512_CHECK=$(cd downloads/ && (echo "${SHA512_HASHES}" | sha512sum -c))
		SHA512_FAILED=$(echo "${SHA512_CHECK}" | grep FAILED)
		if [ -n "${SHA512_FAILED}" ]; then
			die "${SHA512_FAILED}"
		fi

		msg "import ${NAMESPACE}/gentoo:${DATE}"
		"${DOCKER}" import - "${NAMESPACE}/gentoo:${DATE}" < "downloads/${STAGE3}" ||
			die "failed to import gentoo"
	fi

	msg "tag ${NAMESPACE}/gentoo:latest"
	"${DOCKER}" tag -f "${NAMESPACE}/gentoo:${DATE}" "${NAMESPACE}/gentoo:latest" ||
			die "failed to tag gentoo"
}

# If they don't already exist:
#
# * download a portage snapshot and
# * create "${NAMESPACE}/portage-import:${DATE}"
#
# Forcibly tag "${NAMESPACE}/portage-import:${DATE}" with "latest"
import_portage()
{
	msg "import portage"
	if ! repo_exists portage-import; then
		# import portage image from Gentoo mirrors

		for FILE in "${PORTAGE}" "${PORTAGE_SIG}"; do
			if [ ! -f "downloads/${FILE}" ]; then
				wget -O "downloads/${FILE}" "${PORTAGE_URL}${FILE}" ||
					die "failed to download ${PORTAGE_URL}${FILE}"
			fi
		done

		gpg --verify "downloads/${PORTAGE_SIG}" "downloads/${PORTAGE}" ||
			die "insecure digests for portage-import"

		msg "import ${NAMESPACE}/portage-import:${DATE}"
		"${DOCKER}" import - "${NAMESPACE}/portage-import:${DATE}" < "downloads/${PORTAGE}" ||
			die "failed to import portage-import"
	fi

	msg "tag ${NAMESPACE}/portage-import:latest"
	"${DOCKER}" tag -f "${NAMESPACE}/portage-import:${DATE}" "${NAMESPACE}/portage-import:latest" ||
		die "failed to tag portage-import"
}

# extract Busybox for the portage image
#
# Arguments:
#
# 1: SUBDIR target subdirectory for the busybox binary
extract_busybox()
{
	SUBDIR="${1}"
	msg "extract Busybox binary to ${SUBDIR}"
	THIS_DIR=$(dirname $($REALPATH $0))
	CONTAINER="${NAMESPACE}-gentoo-${DATE}-extract-busybox"
	"${DOCKER}" run --name "${CONTAINER}" -v "${THIS_DIR}/${SUBDIR}/":/tmp "${NAMESPACE}/gentoo:${DATE}" cp /bin/busybox /tmp/
	"${DOCKER}" rm "${CONTAINER}"
}

# If it doesn't already exist:
#
# * create "${NAMESPACE}/${REPO}:${DATE}" from
#   "${REPO}/Dockerfile.template"
#
# Forcibly tag "${NAMESPACE}/${REPO}:${DATE}" with "latest"
#
# Arguments:
#
# 1: REPO
build_repo()
{
	REPO="${1}"
	msg "build repo ${REPO}"
	if ! repo_exists "${REPO}"; then
		if [ "${REPO}" = portage ]; then
			extract_busybox "${REPO}"
		fi

		env -i \
			NAMESPACE="${NAMESPACE}" \
			TAG="${DATE}" \
			MAINTAINER="${AUTHOR}" \
			envsubst '
				${NAMESPACE}
				${TAG}
				${MAINTAINER}
				' \
				< "${REPO}/Dockerfile.template" > "${REPO}/Dockerfile"

		msg "build ${NAMESPACE}/${REPO}:${DATE}"
		"${DOCKER}" build ${BUILD_OPTS} -t "${NAMESPACE}/${REPO}:${DATE}" "${REPO}" ||
			die "failed to build ${REPO}"
	fi
	msg "tag ${NAMESPACE}/${REPO}:latest"
	"${DOCKER}" tag -f "${NAMESPACE}/${REPO}:${DATE}" "${NAMESPACE}/${REPO}:latest" ||
			die "failed to tag ${REPO}"
}

build()
{
	import_stage3
	import_portage

	for REPO in ${REPOS}; do
		build_repo "${REPO}"
	done
}

missing()
{
	for REPO in gentoo portage-import ${REPOS}; do
		if ! repo_exists "${REPO}"; then
			msg "${REPO}"
		fi
	done
}

ACTION="${1:-build}"

case "${ACTION}" in
build) build ;;
missing) missing ;;
--help) msg "usage: ${0} [--help] {build|missing}" ;;
*) die "invalid action '${ACTION}'" ;;
esac
