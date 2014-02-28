Run this [ngIRCd][] image with:

    $ docker run -d --name ngircd-0 --hostname irc.example.net \
    >   -e DESCRIPTION="My IRC server" \
    >   -e LOCATION="My attic" \
    >   -e EMAIL="admin@example.net" \
    >   -e INFO="testing, testing" \
    >   -p 6667:6667 wking/ngircd

[ngIRCd]: http://ngircd.barton.de/
