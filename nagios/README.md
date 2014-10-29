Run this [Nagios][] image with:

    $ docker run -d --name nagios-0 -p 80:80 wking/nagios

You'll want to [volume mount][volume-mount] your config.  For example:

    $ docker run -d --name nagios-0 \
    >   -v ~/src/dockerfile/nagios/redis/plugins:/usr/local/bin \
    >   -v ~/src/dockerfile/nagios/redis/cfg:/etc/nagios/cfg \
    >   -p 80:80 \
    >   wking/nagios \
    >   /bin/bash -c '
    >     emerge -v dev-db/redis && rc default && exec tail-syslog
    >     '

Of course, if you were using this in production you'd want to create a
new image `FROM` this one with `dev-db/redis` already installed, after
which you could drop the explicit command.

For information about writing your own plugins, see the [plugin API
docs][plugin-api].  For more information about Nagios on Gentoo, see
the [wiki][].

[Nagios]: http://www.nagios.org/
[volume-mount]: http://docs.docker.com/userguide/dockervolumes/#mount-a-host-directory-as-a-data-volume
[plugin-api]: http://nagios.sourceforge.net/docs/3_0/pluginapi.html
[wiki]: http://wiki.gentoo.org/wiki/Nagios
