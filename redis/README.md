Run this [Redis][] image with:

    $ docker run -d --name redis-0 wking/redis

Then [link][linking] to it from your client container:

    $ docker run --link redis-0:redis your-client

Inside your client, use the `REDIS_PORT` environment variable (which
should be something like `tcp://172.17.0.8:6379`) to configure your
client's Redis connection.  Linking like this *does not* expose the
port on your host interface (that's what `-p` is for).  You can spin
up as many Redis containers as you like (`redis-1`, `redis-2`, …), and
link to any of them from any client container.

[Redis]: http://redis.io/
[linking]: http://docs.docker.io/en/latest/use/port_redirection/#linking-a-container
