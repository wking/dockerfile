Run this [Kibana][] image with:

    $ docker run -d --name kibana-0 -e ELASTICSEARCH_URL=http://es.example.com:9200 -p 80:80 wking/kibana-azure

It's just like the basic `kibana` image, but it's built from my [azure
branch][azure] with a custom default dashboard.

[Kibana]: http://www.elasticsearch.org/overview/kibana/
[azure]: https://github.com/wking/kibana/tree/azure
