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

# usage: C1_PORT=tcp://192.168.0.1:12345/ C1_NAME=a.com \
#        C2_PORT=tcp://192.168.0.2:54321/ C2_NAME=b.net \
#        create-vhosts-from-environment

for NAME_VARIABLE in $(env | sed -n 's/^\([^=]*_NAME\)=.*/\1/p'); do
	URL_VARIABLE="${NAME_VARIABLE%_NAME}_PORT"
	eval NAME="\$$NAME_VARIABLE"
	eval URL="\$$URL_VARIABLE"
	URL="http://${URL#tcp://}"
	env -i \
		NAME="${NAME}" \
		URL="${URL}" \
		envsubst '
			${NAME}
			${URL}
			' \
			< /etc/nginx/vhosts/TEMPLATE > "/etc/nginx/vhosts/${NAME}.conf"
done
