#!/bin/sh

AUTHOR="${AUTHOR:-W. Trevor King <wking@tremily.us>}"
NAMESPACE="${NAMESPACE:-wking}"
#PORTAGE="${PORTAGE:-/usr/portage}"
DATE="${DATE:-20131205}"
MIRROR="${MIRROR:-http://mirror.mcs.anl.gov/pub/gentoo/}"
ARCH_URL="${ARCH_URL:-${MIRROR}/releases/amd64/current-stage3/}"
STAGE3="${STAGE3:-stage3-amd64-${DATE}.tar.bz2}"
STAGE3_CONTENTS="${STAGE3_CONTENTS:-${STAGE3}.CONTENTS}"
STAGE3_DIGESTS="${STAGE3_DIGESTS:-${STAGE3}.DIGESTS.asc}"

REPOS="
	gentoo-portage
	gentoo-en-us
	gentoo-syslog
	buildbot
	"

die()
{
	echo "$1"
	exit 1
}

STAGE3_IMAGES=$(docker images "${NAMESPACE}/gentoo")
STAGE3_MATCHES=$(echo "${STAGE3_IMAGES}" | grep "${DATE}")
if [ -z "${STAGE3_MATCHES}" ]; then
	# import stage3 image from Gentoo mirrors

	for FILE in "${STAGE3}" "${STAGE3_CONTENTS}" "${STAGE3_DIGESTS}"; do
		if [ ! -f "downloads/${FILE}" ]; then
			wget -O "downloads/${FILE}" "${ARCH_URL}/${FILE}"
		fi
	done

	gpg --verify "downloads/${STAGE3_DIGESTS}" || die "insecure digests"
	SHA512_HASHES=$(grep -A1 SHA512 "downloads/${STAGE3_DIGESTS}" | grep -v '^--')
	SHA512_CHECK=$(cd downloads/ && (echo "${SHA512_HASHES}" | sha512sum -c))
	SHA512_FAILED=$(echo "${SHA512_CHECK}" | grep FAILED)
	if [ -n "${SHA512_FAILED}" ]; then
		die "${SHA512_FAILED}"
	fi

	docker import - "${NAMESPACE}/gentoo:${DATE}" < "downloads/${STAGE3}" || die "failed to import"
fi

docker tag -f "${NAMESPACE}/gentoo:${DATE}" "${NAMESPACE}/gentoo:latest" || die "failed to tag"

for REPO in ${REPOS}; do
	REPO_IMAGES=$(docker images "${NAMESPACE}/${REPO}")
	REPO_MATCHES=$(echo "${REPO_IMAGES}" | grep "${DATE}")
	if [ -z "${REPO_MATCHES}" ]; then
		cp "${REPO}/Dockerfile.template" "${REPO}/Dockerfile"
		sed -i "s|TAG|${DATE}|g" "${REPO}/Dockerfile"
		sed -i "s|NAMESPACE|${NAMESPACE}|g" "${REPO}/Dockerfile"
		sed -i "s|MAINTAINER.*|MAINTAINER ${AUTHOR}|g" "${REPO}/Dockerfile"
		docker build -t "${NAMESPACE}/${REPO}:${DATE}" "${REPO}" || die "failed to build"
	fi
	docker tag -f "${NAMESPACE}/${REPO}:${DATE}" "${NAMESPACE}/${REPO}:latest" || die "failed to tag"
done
