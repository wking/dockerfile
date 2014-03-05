Run this [ngIRCd][] image with:

    $ docker run -d --name ngircd-0 --hostname irc.example.net \
    >   -e DESCRIPTION="My IRC server" \
    >   -e LOCATION="My attic" \
    >   -e EMAIL="admin@example.net" \
    >   -e INFO="testing, testing" \
    >   -p 6667:6667 wking/ngircd

For [SSL / TLS][TLS], set the `SSL` environment variable to `yes` or
`optional` and [volume-mount][volume-mount] your keys under the
container's `/etc/ngircd/ssl/`:

    $ docker run -d --name ngircd-0 --hostname irc.example.net \
    >   …
    >   -e SSL=yes \
    >   -v /etc/ssl/ngircd-0:/etc/ngircd/ssl \
    >   -p 6697:6697 wking/ngircd

You'll [need][SSL-docs] at least `server-cert.pem` and
`server-key.pem` in that directory.  If you're using DH or DSA keys,
you'll also want `dhparams.pem` with [Diffie–Hellman][DH] parameters;
you can manage the file with OpenSSH's [dhparam][]).  If you don't
want to require SSL, set `SSL` to `optional` and expose both the
[encrypted port][6697] and the [unencrypted port][6667]:

    $ docker run -d --name ngircd-0 --hostname irc.example.net \
    >   …
    >   -e SSL=optional \
    >   -v /etc/ssl/ngircd-0:/etc/ngircd/ssl \
    >   -p 6667:6667 -p 6697:6697 wking/ngircd

You can optionally set a `GLOBAL_PASSWORD` environment variable to
require a global password for all client connections, although the
password length is [limited to 20 characters since ngIRCd
v0.9][password-limit].

[ngIRCd]: http://ngircd.barton.de/
[TLS]: http://en.wikipedia.org/wiki/Transport_Layer_Security
[volume-mount]: http://docs.docker.io/en/latest/use/working_with_volumes/
[SSL-docs]: http://ngircd.barton.de/doc/SSL.txt
[DH]: http://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange
[dhparam]: http://www.openssl.org/docs/apps/dhparam.html
[6697]: http://tools.ietf.org/html/draft-hartmann-default-port-for-irc-via-tls-ssl-09
[6667]: http://tools.ietf.org/html/draft-hartmann-default-port-for-irc-via-tls-ssl-09#section-1
[password-limit]: http://ngircd.barton.de/doc/INSTALL
