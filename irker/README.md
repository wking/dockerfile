Run this [irker][] image with:

    $ docker run -d --name irker-0 --hostname irker.example.net \
    >   -p 6659:6659 -p 6659:6659/udp wking/irker

which fires up an [irkerd][] daemon.  Then send in your packets as
single-line JSON objects.  You can use [Bash][] [redirection][] to do
that from the command line:

    $ docker inspect irker-0 | grep IPAddress
            "IPAddress": "10.0.0.4",
    $ echo '{"to": "irc://chat.freenode.net/some-channel", "privmsg": "Hello, world!"}' >/dev/tls/10.0.0.4/6659

Opening both TCP and UDP ports has been [supported][tcp-and-udp-pr]
[since Docker 0.7.1][tcp-and-udp-bug].

The current irkerd trunk doesn't support SSL/TLS for server
connections, so I pull in my [updates][ssl-tls] and clobber the
installed `/usr/bin/irkerd`.  I also patch up the stock irkerd init
script.

[irker]: http://www.catb.org/~esr/irker/
[irkerd]: http://www.catb.org/~esr/irker/irkerd.html
[tcp-and-udp-pr]: https://github.com/dotcloud/docker/pull/1177
[tcp-and-udp-bug]: https://github.com/dotcloud/docker/issues/3149
[Bash]: https://www.gnu.org/software/bash/
[redirection]: https://www.gnu.org/software/bash/manual/html_node/Redirections.html
[ssl-tls]: http://git.tremily.us/?p=irker.git;a=shortlog;h=refs/heads/ssl-tls
