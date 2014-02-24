While the `nginx` container serves a single, unnamed host from
`/var/www/localhost/htdocs`, this container uses [Nginx] to proxy a
collection of virtual servers via hostname.  It listens for both
plaintext and [TLS][] connections, and uses [Server Name Indication
(SNI)][SNI] to serve the appropriate [X.509][] certificate.

Run this [Nginx][] image with:

    $ docker run -d --name nginx-a -v /var/www/a.net/htdocs:/var/www/localhost/htdocs wking/nginx
    $ docker run -d --name nginx-b -v /var/www/b.com/htdocs:/var/www/localhost/htdocs wking/nginx
    $ docker run -d --name nginx-proxy-0 --link nginx-a:a -e A_NAME=a.com --link nginx-b:b -e B_NAME=b.net -v /etc/ssl/nginx-proxy-0:/etc/ssl/nginx -p 80:80 -p 443:443 wking/nginx-proxy

[volume-mounting][volume-mount] your certificates and keys under the
container's `/etc/ssl/nginx`.  The `*_NAME` environment variables
override Docker's [default][link-name] `/${LINKER}/${LINKEE}`.  For
example, without th `-e A_NAME=a.com` argument, `A_NAME` would be
`/nginx-proxy-0/a`.  You should avoid link aliases with `-` and `.` in
them, because `A.NET_NAME` is not a valid shell variable.

[HAProxy][] added native SSL support with [version 1.5-dev12
(2012-09-10)][HAProxy-v1.5], but v1.5 isn't stable yet so I think
Nginx is the best tool for this task.

[Nginx]: http://nginx.org/
[TLS]: http://en.wikipedia.org/wiki/Transport_layer_security
[SNI]: http://en.wikipedia.org/wiki/Server_Name_Indication
[X.509]: http://en.wikipedia.org/wiki/X.509
[volume-mount]: http://docs.docker.io/en/latest/use/working_with_volumes/
[link-name]: http://docs.docker.io/en/latest/use/working_with_links_names/
[HAProxy]: http://haproxy.1wt.eu/
[HAProxy-v1.5]: http://haproxy.1wt.eu/download/1.5/src/CHANGELOG
