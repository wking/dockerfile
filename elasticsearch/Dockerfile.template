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

FROM ${NAMESPACE}/gentoo-java:${TAG}
MAINTAINER ${MAINTAINER}
#VOLUME ["${PORTAGE}:/usr/portage:ro", "${PORTAGE}/distfiles:/usr/portage/distfiles:rw"]
RUN echo 'app-misc/elasticsearch ~amd64' >> /etc/portage/package.accept_keywords
RUN emerge -v app-misc/elasticsearch
RUN eselect news read new
RUN rc-update add elasticsearch default
RUN for x in /etc/elasticsearch/*; do cp "${x}" "${x%.sample}"; done

# Log via Syslog
RUN sed -i 's/^\(source src { system(); internal();\) };$/\1 udp(ip(127.0.0.1) port(514)); };/' /etc/syslog-ng/syslog-ng.conf
RUN sed -i 's/^\(rootLogger: .*\), file$/\1, syslog/' /etc/elasticsearch/logging.yml
RUN sed -i 's/^\(appender:\)$/\1\n  syslog:\n    type: syslog\n    syslogHost: localhost:514\n    facility: daemon\n    laout:\n      type: pattern\n      conversionPattern: "[%d{ISO8601}][%-5p][%-25c] %m%n"\n/' /etc/elasticsearch/logging.yml

EXPOSE 9200
