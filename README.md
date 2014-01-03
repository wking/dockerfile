[Dockerfiles][] for assorted [Gentoo][]-based [Docker][] images.

Dockerfiles are sorted into directories with names matching the
suggested repository.  To avoid duplicating ephemeral data (namespace,
timestamp tag, …), they appear in the `Dockerfile.template` as markers
(`${NAMESPACE}`, `${TAG}`, …).  The `build.sh` script replaces the
markers with values while generating a `Dockerfile` from each
`Dockerfile.template` (using [envsubst][]), and then builds each tag
with:

    $ docker build -t $NAMESPACE/$REPO:$TAG $REPO

for example:

    $ docker build -t wking/gentoo-en-us:20131205 gentoo-en-us

The dependency graph is:

    wking/gentoo  (amd64 stage3)
    `-- gentoo-portage  (adds portage directory)
        `-- gentoo-en-us  (adds locale)
            `-- gentoo-syslog  (adds syslog-ng and associates)
                |-- buildbot  (adds a Buildbot master and slave)
                |-- memcached  (adds Memcached)
                |-- nginx  (adds Nginx)
                |   |-- nginx-proxy  (SSL/TLS proxying via SNI)
                |   `-- kibana  (adds Kibana)
                |-- postgresql  (adds PostgreSQL)
                |-- redis  (adds Redis)
                |-- stunnel  (adds stunnel)
                `-- gentoo-java  (adds IcedTea)
                    `-- elasticsearch  (adds Elasticsearch)

Run:

    $ ./build.sh

to seed from the Gentoo mirrors and build all images.  There are a
number of variables in the `build.sh` script that configure the build
(`AUTHOR`, `NAMESPACE`, …).  We use [POSIX parameter
expansion][parameter-expansion] to make it easy to override variables
as you see fit.

    $ NAMESPACE=jdoe DATE=20131210 ./build.sh

I'd like to avoid bloating the images with the Portage tree, but
without ugly hacks [that is not currently possible][3156] is mounted
from the host.

[Docker]: http://www.docker.io/
[Dockerfiles]: http://www.docker.io/learn/dockerfile/
[Gentoo]: http://www.gentoo.org/
[envsubst]: http://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html
[parameter-expansion]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
[3156]: https://github.com/dotcloud/docker/issues/3156
