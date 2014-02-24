Run this [Memcached][] image with:

    $ docker run -d --name memcached-0 -m 128m -e MEMUSAGE=118 wking/memcached

The 10MB difference between container memory and the
Memcached-specific `MEMUSAGE` limit gives some overhead for the
`memcached` process itself and auxilliary processes to ensure that
`MEMUSAGE` stops us before we hit “out of memory” errors.

Then [link][linking] to it from your client container:

    $ docker run --link memcached-0:memcached your-client

Inside your client, use the `MEMCACHED_PORT` environment variable
(which should be something like `tcp://172.17.0.8:11211`) to configure
your client's Memcached connection.  Linking like this *does not*
expose the port on your host interface (that's what `-p` is for).  You
can spin up as many Memcached containers as you like (`memcached-1`,
`memcached-2`, …), and link to any of them from any client container.

[Memcached]: http://memcached.org/
[linking]: http://docs.docker.io/en/latest/use/port_redirection/#linking-a-container
