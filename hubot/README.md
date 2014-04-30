This image has a custom [hubot][] with the [hubot-irc][] adapter and a
number of [scripts][] installed out of the box:

* [github-commit-link][]
* [github-commits][]
* [github-issue-link][]
* [github-issues][]
* [github-pull-request-notifier][]
* [github-logger][]

It's also easy to [write your own scripts][scripting].

Run this [hubot][] image with:

    $ docker run -d --name hubot-0 \
    >   -e HUBOT_IRC_NICK="myhubot" \
    >   -e HUBOT_IRC_USESSL="true" \
    >   -e HUBOT_IRC_SERVER="irc.freenode.net" \
    >   -e HUBOT_IRC_PORT="6697" \
    >   -e HUBOT_IRC_ROOMS="#my-channel, #my-other-channel" \
    >   -e HUBOT_IRC_UNFLOOD="200" \
    >   -e HUBOT_GITHUB_USER="github" \
    >   -e HUBOT_GITHUB_REPO="github/hubot" \
    >   -e LOG_HTTP_USER="logs" \
    >   -e LOG_HTTP_PASS="changme" \
    >   -e LOG_HTTP_PORT=8000" \
    >   --link redis-0:redis \
    >   -p 80:80 \
    >   -p 8000:8000 \
    >   wking/hubot

If your IRC server requires a server-wide password, you can set
`HUBOT_IRC_PASSWORD`.

The [link][] to `redis-0` is for the default [redis-brain][] script.
You should be able to link to any Redis server, but this Dockerfile
repository already [provides one][redis].

If you want the GitHub scripts to be able to access private
repositories (e.g. to link to private issues or commits), you need to
set `HUBOT_GITHUB_TOKEN` to your [OAuth token][token].

If things aren't working as you'd expect, you can crank up the logging
with `HUBOT_LOG_LEVEL=debug` (see [robot.coffee][]).

[hubot]: https://github.com/github/hubot
[hubot-irc]: https://github.com/nandub/hubot-irc
[scripts]: https://github.com/github/hubot-scripts/tree/master/src/scripts
[github-commit-link]: https://github.com/github/hubot-scripts/blob/master/src/scripts/github-commit-link.coffee
[github-commits]: https://github.com/github/hubot-scripts/blob/master/src/scripts/github-commits.coffee
[github-issue-link]: https://github.com/github/hubot-scripts/blob/master/src/scripts/github-issue-link.coffee
[github-issues]: https://github.com/github/hubot-scripts/blob/master/src/scripts/github-issues.coffee
[github-pull-request-notifier]: https://github.com/github/hubot-scripts/blob/master/src/scripts/github-pull-request-notifier.coffee
[github-logger]: https://github.com/jenrzzz/hubot-logger
[scripting]: https://github.com/github/hubot/blob/master/docs/scripting.md
[link]: http://docs.docker.io/en/latest/use/port_redirection/#linking-a-container
[redis-brain]: https://github.com/github/hubot-scripts/blob/master/src/scripts/redis-brain.coffee
[redis]: ../redis/
[token]: https://help.github.com/articles/creating-an-access-token-for-command-line-use
[robot.coffee]: https://github.com/github/hubot/blob/master/src/robot.coffee
