Run this [Elasticsearch][] image with:

    $ docker run -d --name elasticsearch-0 wking/elasticsearch

Then [link][linking] to it from your client container:

    $ docker run --link elasticsearch-0:elasticsearch your-client

For example, we can use the Gentoo client:

    $ docker run --link elasticsearch-0:elasticsearch -i -t wking/gentoo /bin/bash
    d30608cbc8a1 / # HOST_PORT="${ELASTICSEARCH_PORT#[a-z]*://}"
    d30608cbc8a1 / # HOST="${HOST_PORT%:[0-9]*}"
    d30608cbc8a1 / # PORT="${HOST_PORT#[0-9.]*:}"
    d30608cbc8a1 / # wget --quiet -O - "http://${HOST}:${PORT}/"
    {
      "ok" : true,
      "status" : 200,
      "name" : "Asbestos Man",
      "version" : {
        "number" : "0.90.6",
        "build_hash" : "e2a24efdde0cb7cc1b2071ffbbd1fd874a6d8d6b",
        "build_timestamp" : "2013-11-04T13:44:16Z",
        "build_snapshot" : false,
        "lucene_version" : "4.5.1"
      },
      "tagline" : "You Know, for Search"
    }

[Elasticsearch]: http://www.elasticsearch.org/
[linking]: http://docs.docker.io/en/latest/use/port_redirection/#linking-a-container
