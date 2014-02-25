Run this [Salt Stack][salt] minion image with:

    $ docker run -d --name salt-minion-0 --hostname salt-minion-0 wking/salt-minion

The [default master name][master-name] is `salt`, so make sure that
resolves appropriately on your Docker host (via DNS or an entry in
`/etc/hosts`).

Minion keys
===========

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

Minion caching
==============

If you blow away a minion container and replace it with a
freshly-spawned container, you may get errors in the minion logs like:

    Feb 25 20:14:18 salt-minion-0 2014-02-25 20:14:18,257 [salt.fileclient  ][INFO    ] Fetching file ** done ** 'elasticsearch/init.sls'
    Feb 25 20:14:18 salt-minion-0 2014-02-25 20:14:18,289 [salt.state       ][INFO    ] Executing state file.managed for /etc/portage/package.use/elasticsearch
    Feb 25 20:14:18 salt-minion-0 2014-02-25 20:14:18,396 [salt.fileclient  ][INFO    ] Fetching file ** done ** 'elasticsearch/files/gentoo/package.use'
    Feb 25 20:14:18 salt-minion-0 2014-02-25 20:14:18,402 [salt.state       ][ERROR   ] An exception occurred in this state: Traceback (most recent call last):
      File "/usr/lib64/python2.7/site-packages/salt/state.py", line 1305, in call
        *cdata['args'], **cdata['kwargs'])
      File "/usr/lib64/python2.7/site-packages/salt/states/file.py", line 1157, in managed
        dir_mode)
      File "/usr/lib64/python2.7/site-packages/salt/modules/file.py", line 2150, in manage_file
        __opts__['cachedir'])
      File "/usr/lib64/python2.7/site-packages/salt/utils/__init__.py", line 599, in copyfile
        '[Errno 2] No such file or directory: {0}'.format(source)
    IOError: [Errno 2] No such file or directory: /var/cache/salt/minion/files/base/elasticsearch/files/gentoo/package.use

That's because the master expects the salt state to be cached on the
old container.  To fill in the cache on the new container, you'll want
to [manually sync][sync_all] the minion:

    salt# salt salt-minion-0 saltutil.sync_all

[salt]: http://saltstack.com/community.html
[master-name]: http://docs.saltstack.com/ref/configuration/minion.html#master
[preseed]: http://docs.saltstack.com/topics/tutorials/preseed_key.html
[volume-mount]: http://docs.docker.io/en/latest/use/working_with_volumes/
[auto-accept]: http://docs.saltstack.com/ref/configuration/master.html#auto-accept
[sync_all]: http://docs.saltstack.com/ref/modules/all/salt.modules.saltutil.html#salt.modules.saltutil.sync_all
