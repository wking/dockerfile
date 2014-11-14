Run this [Salt Stack][salt] master image with:

    $ docker run -d --name salt-master-0 --hostname salt \
    >   -p 4505:4505 -p 4506:4506 wking/salt-master

For details on setting up minion keys, see the “Minion keys” section
of the [salt-minion][] `README`.  To preserve accepted keys between
container restarts, you can [volume-mount][] them from your host:

    $ docker run -d --name salt-master-0 --hostname salt \
    >   -v /etc/salt/pki/salt-master-0:/etc/salt/pki/master \
    >   -p 4505:4505 -p 4506:4506 wking/salt-master

You can use `docker exec` ([new in 1.3][docker-1.3], [docs][exec]) to
connect to the master container when you need to run `salt` commands.

[salt]: http://saltstack.com/community/
[salt-minion]: ../salt-minion/
[volume-mount]: http://docs.docker.com/userguide/dockervolumes/#mount-a-host-directory-as-a-data-volume
[docker-1.3]: http://blog.docker.com/2014/10/docker-1-3-signed-images-process-injection-security-options-mac-shared-directories/
[exec]: http://docs.docker.com/reference/commandline/cli/#exec
