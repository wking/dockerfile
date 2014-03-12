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

# required by irker (argument)
RUN echo '=net-irc/irker-1.20 ~amd64' >> /etc/portage/package.accept_keywords

# Work around https://bugs.gentoo.org/show_bug.cgi?id=503350
#
# net-irc/irker-1.20 depends on dev-python/irc, but that dependency
# was actually removed in irker v1.20 [1].  Still, we need to keep
# this workaround until a new ebuild drops that dependency [2,3].
#
# [1]: https://gitorious.org/irker/irker/commit/79a38e602ba429fef7d5842d3390c51e631795f6
# [2]: https://bugs.gentoo.org/show_bug.cgi?id=438240
# [3]: https://bugs.gentoo.org/show_bug.cgi?id=491808#c0
RUN echo '=dev-python/irc-8.5.4 ~amd64' >> /etc/portage/package.accept_keywords
RUN emerge -v dev-python/setuptools

RUN emerge -v net-irc/irker

RUN emerge -v dev-vcs/git
RUN git clone --branch next --single-branch --depth 1 git://tremily.us/irker.git
RUN cp -f irker/irkerd /usr/bin/irkerd

RUN eselect news read new
RUN sed -i 's/\(start-stop-daemon --start.*--quiet\) \(--exec $command\)$/\1 --pidfile ${pidfile} --make-pidfile --background \2 -- $command_args/' /etc/init.d/irkerd
RUN sed -i 's/\(start-stop-daemon --stop --quiet\)/\1 --pidfile ${pidfile}/' /etc/init.d/irkerd
RUN sed -i 's/#IRKERD_OPTS=""/IRKERD_OPTS="--host 0.0.0.0 --syslog"/' /etc/conf.d/irkerd
RUN rc-update add irkerd default

EXPOSE 6659
