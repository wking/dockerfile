Run this [package-cache][] image with:

    $ docker run -d --name package-cache-0 -v /var/cache/package-cache-0:/usr/portage -p 4000:80 wking/package-cache

[volume-mounting][volume-mount] your content under the container's
`/usr/portage`.  Then setup you host firewall to intercept outgoing
connections to [distfiles.gentoo.org][] and redirect them to the
package cacher.  Use [jq][] to extract the package-cache IP address:

    # CACHE_IP=$(docker inspect package-cache-0 |
    > jq -r '.[0].NetworkSettings.IPAddress')

And add a destination address translation rule, using [dig][] to list
IP addresses for the source:

    # for SOURCE_IP in $(dig +short distfiles.gentoo.org);
    > do
    >   iptables --table nat --append PREROUTING --protocol tcp \
    >     --in-interface docker0 ! --source "${CACHE_IP}" \
    >     --destination "${SOURCE_IP}" \
    >     --match tcp --destination-port 80 \
    >     --jump DNAT --to-destination "${CACHE_IP}:80" ;
    > done

To remove those entries later, repeat the command with `--delete`
instead of `--append`.  You may need to list the `SOURCE_IP` values
explicitly if the DNS entries have changed.  Run:

    # iptables --table nat --list PREROUTING --numeric

to list the entries.  See `iptables(8)` and `iptables-extensions(8)`
for more details.

[package-cache]: http://blog.tremily.us/posts/package-cache/
[volume-mount]: http://docs.docker.io/en/latest/use/working_with_volumes/
[distfiles.gentoo.org]: http://distfiles.gentoo.org/
[jq]: http://stedolan.github.io/jq/
[dig]: ftp://ftp.isc.org/isc/bind9/cur/9.9/doc/arm/man.dig.html
