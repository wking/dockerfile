Use this [stunnel][] image to wrap other containers in SSL/TLS
encryption using Docker's [linking][].  You'll want to
[volume-mount][volume-mount] your SSL keys, since you may want
different keys in every stunnel container.

    $ docker run -d --name postgresql-0 wking/postgresql
    $ docker run -d --name postgresql-0-ssl -v /etc/postgresql-0-ssl/stunnel.pem:/etc/stunnel/stunnel.pem --link postgresql-0:server -p 5432:9999 wking/stunnel

[PostgreSQL][] [uses plaintext commands to initiate SSL/TLS
encryption][SSLRequest] so you can't use `psql` to connect directly to
this client.  You can use it for protocols that use SSL/TLS from the
start (e.g. HTTPS).  If you need support for an initially unencrypted
protocol, your best bet is to avoid stunnel and use the SSL/TLS
support in the server itself.  Failing that, you can always setup a
client-side stunnel, and have both the server and client think they're
talking in the clear.

[stunnel]: https://www.stunnel.org/
[linking]: http://docs.docker.io/en/latest/use/port_redirection/#linking-a-container
[volume-mount]: http://docs.docker.io/en/latest/use/working_with_volumes/#mount-a-host-directory-as-a-container-volume
[PostgreSQL]: http://postgresql.io/
[SSLRequest]: http://www.postgresql.org/docs/devel/static/protocol-flow.html#AEN100370
