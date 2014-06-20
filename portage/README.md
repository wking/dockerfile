Use volume mounts to avoid including the Portage tree in your images:

    $ docker run --name portage wking/portage

The container will exit immediately, but you can still
[mount][volumes-from] it's exported [VOLUME][] from another container:

    $ docker run --volumes-from portage -i -t wking/gentoo /bin/bash
    d1a49abc4b3c / # ls /usr/portage/
    app-accessibility  dev-python        mail-mta         sci-mathematics
    …

Changes (e.g. distfiles downloads) are preserved between mounts by the
shared `portage` container.  Let's install something in the first
container:

    d1a49abc4b3c / # emerge -av netcat
    …
    These are the packages that would be fetched, in order:

    Calculating dependencies... done!
    [ebuild  N     ] dev-libs/libmix-2.05-r6  USE="-static-libs" 78 kB
    [ebuild  N     ] net-analyzer/netcat-110-r9  USE="crypt ipv6 -static" 108 kB

    Total: 2 packages (2 new), Size of downloads: 186 kB

Now kill that container and spin up another one:

    $ docker run --volumes-from portage -i -t wking/gentoo /bin/bash
    187adaf8babd / # emerge -pv netcat
    …
    These are the packages that would be merged, in order:

    Calculating dependencies... done!
    [ebuild  N     ] dev-libs/libmix-2.05-r6  USE="-static-libs" 0 kB
    [ebuild  N     ] net-analyzer/netcat-110-r9  USE="crypt ipv6 -static" 0 kB

    Total: 2 packages (2 new), Size of downloads: 0 kB
    …

The local Portage cache, read news items, etc. stored outside of
`/usr/portage` (e.g. in `/var/cache/edb`, `/var/lib/gentoo/news`, …)
will still be local to your client containers, so you'll get
promptings for reading the news on both `d1a49abc4b3c` and
`187adaf8babd`.

You can use container volumes even if their container is not running
(as above), but it may be useful to leave the container running so you
don't remove it up by accident.  For example:

    $ docker run -d --name portage wking/portage /bin/sh -c 'tail -f /usr/portage/profiles/repo_name'

[VOLUME]: http://docs.docker.io/en/latest/use/builder/#volume
[volumes-from]: http://docs.docker.io/en/latest/use/working_with_volumes/#mount-volumes-from-an-existing-container
