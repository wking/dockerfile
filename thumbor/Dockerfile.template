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

FROM ${NAMESPACE}/gentoo-layman:${TAG}
MAINTAINER ${MAINTAINER}
#VOLUME ["${PORTAGE}:/usr/portage:ro", "${PORTAGE}/distfiles:/usr/portage/distfiles:rw"]
RUN sed -i 's/\(PYTHON_TARGETS\)=.*/\1="python2_7"/' /etc/portage/make.conf
RUN sed -i 's/\(PYTHON_SINGLE_TARGET\)=.*/\1="python2_7"/' /etc/portage/make.conf
RUN echo 'USE_PYTHON="2.7"' >> /etc/portage/make.conf
RUN emerge -v --newuse --deep --with-bdeps=y @system @world
RUN echo 'YES' | etc-update --automode -9
# https://bugs.gentoo.org/show_bug.cgi?id=526528
RUN rm /etc/layman/._*
RUN eselect python set $(eselect python show --python2)
RUN echo 'USE="${USE} jpeg tiff truetype webp"' >> /etc/portage/make.conf
RUN layman --overlays http://blog.tremily.us/posts/Gentoo_overlay/layman.xml --sync-all
RUN layman --overlays http://blog.tremily.us/posts/Gentoo_overlay/layman.xml --add wtk
COPY package.accept_keywords /etc/portage/package.accept_keywords/thumbor
RUN emerge -v dev-python/thumbor
RUN eselect news read new
# Currently no syslog support, so don't bother
#   https://github.com/thumbor/thumbor/issues/377
#RUN rc-update add thumbor default

EXPOSE 8888
CMD thumbor --port 8888 --conf /etc/thumbor/thumbor.conf
