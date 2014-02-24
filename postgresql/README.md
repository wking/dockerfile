Run this [PostgreSQL][] image with:

    $ docker run -d --name postgresql-0 wking/postgresql

Then [link][linking] to it from your client container:

    $ docker run --link postgresql-0:postgresql your-client

For example, we can use the PostgreSQL client in the
`wking/postgresql` image itself:

    $ docker run --link postgresql-0:postgresql -i -t wking/postgresql /bin/bash
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

To allow mounting a large database ([devicemapper only supports
16GB][devicemapper-size-limit]) we declare `/var/lib/postgresql` as a
[VOLUME][].  This means that `/var/lib/postgresql` is stored outside
the image (under `/var/lib/docker/vfs/dir` with metadata under
`/var/lib/docker/volumes`) and mounted automatically when you spin up
a container.  From a [pending version][fd24041] of [issue 3389][3389]:

> If you remove containers that mount volumes, including the initial
> `DATA` container, or the middleman, the volumes will not be deleted
> until there are no containers still referencing those volumes. This
> allows you to upgrade, or effectivly migrate data volumes between
> containers.

That means you should be able to migrate your `/var/lib/postgresql`
data to new PostgreSQL containers (e.g. if you upgrade PostgreSQL).

[PostgreSQL]: http://postgresql.io/
[linking]: http://docs.docker.io/en/latest/use/port_redirection/#linking-a-container
[devicemapper-size-limit]: https://www.kernel.org/doc/Documentation/device-mapper/thin-provisioning.txt
[VOLUME]: http://docs.docker.io/en/latest/use/working_with_volumes/#getting-started
[fd24041]: https://github.com/SvenDowideit/docker/commit/fd240413ff835ee72741d839dccbee24e5cc410c
[3389]: https://github.com/dotcloud/docker/pull/3389
