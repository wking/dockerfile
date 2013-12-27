Run this [PostgreSQL][] image with:

    $ docker run -d -name postgresql-0 wking/postgresql

Then [link][linking] to it from your client container:

    $ docker run -link postgresql-0:postgresql your-client

For example, we can use the PostgreSQL client in the
`wking/postgresql` image itself:

    $ docker run -link postgresql-0:postgresql -i -t wking/postgresql /bin/bash
    94ca64e60a00 / # HOST_PORT="${POSTGRESQL_PORT#[a-z]*://}"
    94ca64e60a00 / # HOST="${HOST_PORT%:[0-9]*}"
    94ca64e60a00 / # PORT="${HOST_PORT#[0-9.]*:}"
    94ca64e60a00 / # psql -h "${HOST}" -p "${PORT}" -U postgres
    psql (9.2.4)
    Type "help" for help.

    postgres=# help
    You are using psql, the command-line interface to PostgreSQL.
    …

The exposed port is not proxied by the host:

    $ docker port postgresql-0 5432
    2013/12/12 15:56:28 Error: No public port '5432' published for postgresql-0

But you can access it if you know the IP:

    $ psql -h 10.0.0.12 -p 5432 -U postgres
    psql (9.2.4)
    Type "help" for help.

    postgres=#

You can also access it from unlinked containers:

    $ docker run -i -t wking/postgresql /bin/bash
    8ee7a0597619 / # psql -h 10.0.0.12 -p 5432 -U postgres
    psql (9.2.4)
    Type "help" for help.

    postgres=# …

Basically, anyone with access to the `docker0` bridge has access to
the client's port.

If you're going to be loading a large database ([devicemapper only
supports 16GB][devicemapper-size-limit]), you may want to
[volume-mount] the database.  Grab the configured stuff we'll want to
mount:

    # docker run -d -name postgresql-0 wking/postgresql
    # docker cp postgresql-0:/var/lib/postgresql/ /var/lib/
    # mv /var/lib/postgresql/ /var/lib/postgresql-0
    # docker kill postgresql-0
    # docker rm postgresql-0

And run future containers with:

    $ docker run -d -name postgresql-0 -v /var/lib/postgresql-0:/var/lib/postgresql wking/postgresql

[PostgreSQL]: http://postgresql.io/
[linking]: http://docs.docker.io/en/latest/use/port_redirection/#linking-a-container
[devicemapper-size-limit]: https://www.kernel.org/doc/Documentation/device-mapper/thin-provisioning.txt
[volume-mount]: http://docs.docker.io/en/latest/use/working_with_volumes/#mount-a-host-directory-as-a-container-volume
