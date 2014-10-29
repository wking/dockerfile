This directory includes a `check_redis_list_length` plugin and sample
Nagios config for monitoring the length of a [Redis][] list.  If
you're using Redis as your [Celery][] [broker][], the list name should
match your queue name.  You'll need the command line `redis-cli` to
run the plugin.

[Redis]: http://redis.io/
[Celery]: http://celery.readthedocs.org/en/latest/
[broker]: http://celery.readthedocs.org/en/latest/getting-started/brokers/redis.html
