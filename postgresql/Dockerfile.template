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

FROM ${NAMESPACE}/gentoo-syslog:${TAG}
MAINTAINER ${MAINTAINER}
#VOLUME ["${PORTAGE}:/usr/portage:ro", "${PORTAGE}/distfiles:/usr/portage/distfiles:rw"]
RUN emerge -v dev-db/postgresql-server
RUN eselect news read new
RUN rc-update add $(basename /etc/init.d/postgresql-*) default
RUN yes | emerge --config dev-db/postgresql-server
VOLUME ["/var/lib/postgresql"]

# Expose PostgreSQL to external network connections
RUN sed -i "s/\(#listen_addresses =.*\)/listen_addresses = '*'\n\1/" /etc/postgresql*/postgresql.conf
RUN echo host  all  all  0.0.0.0/0  trust >> $(echo /etc/postgresql*/pg_hba.conf)

# Setup logging
RUN sed -i "s/\(#log_destination =.*\)/log_destination = 'syslog'\n\1/" /etc/postgresql*/postgresql.conf

EXPOSE 5432
