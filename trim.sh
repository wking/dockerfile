#!/bin/sh
#
# Copyright (C) 2013-2014 W. Trevor King <wking@tremily.us>
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

die()
{
	echo "$1"
	exit 1
}

trim()
{
	IMAGE="$1"
	NAMESPACE_REPOSITORY="${IMAGE%:*}"
	TAG="${IMAGE#*:}"
	if [ "${TAG}" = "${NAMESPACE_REPOSITORY}" ]
	then
		TAG=""
	fi
	REPOSITORY="${NAMESPACE_REPOSITORY#*/}"
	CONTAINER="${REPOSITORY}-trimmed-container"
	IMG="${NAMESPACE_REPOSITORY}-trimmed"
	if [ -n "${TAG}" ]
	then
		IMG="${IMG}:${TAG}"
	fi
	docker run -t --name "${CONTAINER}" \
		-v "${PWD}/empty-system.py:/tmp/empty-system.py" \
		"${IMAGE}" /bin/bash -c "
			/tmp/empty-system.py &&
			emerge -v --with-bdeps=n --depclean &&
			rm -rf /usr/portage" ||
		die "failed to create ${CONTAINER}"
	docker export "${CONTAINER}" | docker import - "${IMG}" ||
		die "failed to export/import ${IMG}"
	docker rm "${CONTAINER}" ||
		die "failed to remove ${CONTAINER}"
}

for IMAGE in "$@"
do
	trim "${IMAGE}"
done
