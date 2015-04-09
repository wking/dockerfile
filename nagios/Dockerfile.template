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

FROM ${NAMESPACE}/gentoo-syslog:${TAG}
MAINTAINER ${MAINTAINER}
#VOLUME ["${PORTAGE}:/usr/portage:ro", "${PORTAGE}/distfiles:/usr/portage/distfiles:rw"]
RUN mkdir -p /etc/portage/package.use
RUN echo 'media-libs/gd jpeg png' >> /etc/portage/package.use/nagios
RUN echo 'net-analyzer/nagios-core lighttpd' >> /etc/portage/package.use/nagios
RUN echo 'net-analyzer/nagios-plugins nagios-dns nagios-ntp nagios-ssh' >> /etc/portage/package.use/nagios
RUN echo 'dev-lang/php cgi' >> /etc/portage/package.use/nagios
RUN emerge -v net-analyzer/nagios
RUN eselect news read new
ADD lighttpd-syslog.conf /etc/lighttpd/syslog.conf
RUN echo 'include "mod_fastcgi.conf"' >> /etc/lighttpd/lighttpd.conf
RUN echo 'include "syslog.conf"' >> /etc/lighttpd/lighttpd.conf
ADD lighttpd-nagios.conf /etc/lighttpd/nagios.conf
RUN echo 'include "nagios.conf"' >> /etc/lighttpd/lighttpd.conf
# https://bugs.gentoo.org/show_bug.cgi?id=528184
RUN chmod 755 /etc/nagios
RUN sed -i 's|\(#use_timezone=Australia/Brisbane\)|\1\nuse_timezone=UTC|' /etc/nagios/nagios.cfg
RUN sed -i 's|\(;date.timezone.*\)|\1\ndate.timezone = "UTC"|' /etc/php/*/php.ini
RUN sed -i 's|\(#default_user_name=.*\)|\1\ndefault_user_name=guest|' /etc/nagios/cgi.cfg
RUN sed -i 's|\(authorized_for_system_information=.*\)|\1,guest|' /etc/nagios/cgi.cfg
RUN sed -i 's|\(authorized_for_configuration_information=.*\)|\1,guest|' /etc/nagios/cgi.cfg
RUN sed -i 's|\(authorized_for_all_services=.*\)|\1,guest|' /etc/nagios/cgi.cfg
RUN sed -i 's|\(authorized_for_all_hosts=.*\)|\1,guest|' /etc/nagios/cgi.cfg
RUN sed -i 's|\(authorized_for_read_only=.*\)|\1,guest|' /etc/nagios/cgi.cfg
ADD no-localhost-ssh.patch /usr/local/share/no-localhost-ssh.patch
RUN patch -p1 < /usr/local/share/no-localhost-ssh.patch
RUN mkdir /etc/nagios/cfg
RUN chown nagios:nagios /etc/nagios/cfg
RUN sed -i 's|\(#cfg_dir=/etc/nagios/routers.*\)|\1\ncfg_dir=/etc/nagios/cfg|' /etc/nagios/nagios.cfg
RUN rc-update add nagios default
RUN rc-update add lighttpd default

EXPOSE 80
