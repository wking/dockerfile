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

FROM ${NAMESPACE}/gentoo-node:${TAG}
MAINTAINER ${MAINTAINER}
#VOLUME ["${PORTAGE}:/usr/portage:ro", "${PORTAGE}/distfiles:/usr/portage/distfiles:rw"]
RUN emerge -v dev-vcs/git
RUN eselect news read new
RUN npm install -g hubot coffee-script
RUN hubot --create hubot
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "redis": "0.8.4",/' hubot/package.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "hubot-irc": "0.2.1",/' hubot/package.json

RUN sed -i 's/\]$/,\n "github-commit-link.coffee"]/' hubot/hubot-scripts.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\1  "githubot": "0.4.x",/' hubot/package.json

RUN sed -i 's/\]$/,\n "github-commits.coffee"]/' hubot/hubot-scripts.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "url": "",/' hubot/package.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "querystring": "",/' hubot/package.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "gitio2": "2.0.0",/' hubot/package.json

RUN sed -i 's/\]$/,\n "github-issue-link.coffee"]/' hubot/hubot-scripts.json
#RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "githubot": "0.4.x",/' hubot/package.json

RUN sed -i 's/\]$/,\n "github-issues.coffee"]/' hubot/hubot-scripts.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "underscore": "1.3.3",/' hubot/package.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "underscore.string": "2.1.1",/' hubot/package.json
#RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "githubot": "0.4.x",/' hubot/package.json

RUN sed -i 's/\]$/,\n "github-pull-request-notifier.coffee"]/' hubot/hubot-scripts.json
#RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "url": "",/' hubot/package.json
#RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "querystring": "",/' hubot/package.json

RUN sed -i 's/\]$/,\n "logger.coffee"]/' hubot/hubot-scripts.json
#RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "redis": ">=0.7.2",/' hubot/package.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "moment": ">=1.7.0",/' hubot/package.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "connect": ">=2.4.5",/' hubot/package.json
RUN sed -i 's/\([[:space:]]*\)\("dependencies": {\)/\1\2\n\1  "connect_router": "*",/' hubot/package.json

RUN cd hubot && npm install
RUN git clone git://github.com/jenrzzz/hubot-logger.git && cp hubot-logger/logger.coffee hubot/node_modules/hubot-scripts/src/scripts/

CMD cd hubot && REDIS_URL="${REDIS_PORT}" LOG_REDIS_URL="${REDIS_PORT}" PORT=80 exec bin/hubot --name "${HUBOT_IRC_NICK:-hubot}" -a irc
EXPOSE 80
EXPOSE 8000
