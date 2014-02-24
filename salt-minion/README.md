Run this [Salt Stack][salt] minion image with:

    $ docker run -d --name salt-minion-0 --hostname salt-minion-0 wking/salt-minion

The [default master name][master-name] is `salt`, so make sure that
resolves appropriately on your Docker host (via DNS or an entry in
`/etc/hosts`).

You have two options for setting up minon keys.  The more secure
approach is to create and install minion keys on the master:

    salt# mkdir /tmp/salt-minion-0
    salt# chmod 700 /tmp/salt-minion-0
    salt# salt-key --gen-keys=minion --gen-keys-dir=/tmp/salt-minion-0
    salt# cp /tmp/salt-minion-0/minion.pub /etc/salt/pki/master/minions/salt-minion-0
    salt# cp /etc/salt/pki/master/master.pub /tmp/salt-minion-0/minion_master.pub
    salt# scp -rp /tmp/salt-minion-0/ docker-host:/etc/salt/pki/salt-minion-0/
    salt# rm -rf /tmp/salt-minion-0

and [preseed the minion][preseed] with a [volume
mount][volume-mount]:

    $ docker run -d --name salt-minion-0 --hostname salt-minion-0 \
    >   -v /etc/salt/pki/salt-minion-0:/etc/salt/pki/minion wking/salt-minion

The less secure approach is to [auto-accept][] the minion's
internally-generated key.

[salt]: http://saltstack.com/community.html
[master-name]: http://docs.saltstack.com/ref/configuration/minion.html#master
[preseed]: http://docs.saltstack.com/topics/tutorials/preseed_key.html
[volume-mount]: http://docs.docker.io/en/latest/use/working_with_volumes/
[auto-accept]: http://docs.saltstack.com/ref/configuration/master.html#auto-accept
