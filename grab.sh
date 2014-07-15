#!/bin/sh
#
# Copyright (C) 2014 W. Trevor King <wking@tremily.us>
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

MIRROR="${MIRROR:-http://distfiles.gentoo.org/}"
BASE_ARCH_URL="${BASE_ARCH_URL:-${MIRROR}releases/amd64/autobuilds/}"
LATEST=$(wget -O - "${BASE_ARCH_URL}latest-stage3.txt")
DATE=$(echo "${LATEST}" | sed -n 's|/stage3-amd64-[0-9]*[.]tar[.]bz2||p')
ARCH_URL="${ARCH_URL:-${BASE_ARCH_URL}${DATE}/}"
STAGE3="${STAGE3:-stage3-amd64-${DATE}.tar.bz2}"
STAGE3_CONTENTS="${STAGE3_CONTENTS:-${STAGE3}.CONTENTS}"
STAGE3_DIGESTS="${STAGE3_DIGESTS:-${STAGE3}.DIGESTS.asc}"
PORTAGE_URL="${PORTAGE_URL:-${MIRROR}snapshots/}"
PORTAGE="${PORTAGE:-portage-${DATE}.tar.xz}"
PORTAGE_SIG="${PORTAGE_SIG:-${PORTAGE}.gpgsig}"

die()
{
	echo "$1"
	exit 1
}

for FILE in "${STAGE3}" "${STAGE3_CONTENTS}" "${STAGE3_DIGESTS}"; do
	if [ ! -f "downloads/${FILE}" ]; then
		wget -O "downloads/${FILE}" "${ARCH_URL}${FILE}"
		if [ "$?" -ne 0 ]; then
			rm -f "downloads/${FILE}" &&
			die "failed to download ${ARCH_URL}${FILE}"
		fi
	fi
done

for FILE in "${PORTAGE}" "${PORTAGE_SIG}"; do
	if [ ! -f "downloads/${FILE}" ]; then
		wget -O "downloads/${FILE}" "${PORTAGE_URL}${FILE}" ||
		if [ "$?" -ne 0 ]; then
			rm -f "downloads/${FILE}" &&
			die "failed to download ${PORTAGE_URL}${FILE}"
		fi
	fi
done

sed -i "s/DATE=.*/DATE=\"\${DATE:-${DATE}}\"/" build.sh
