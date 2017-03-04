# Creating a simple monitoring system using ELK stack and Docker

This fodler contains docker recipes to run a ELK based monitoring system. 

Strat each of the containers in this order

### Elasticsearch

From ```devops-starter-exercise/pipeline/monitoring``` create folders for keeping elasticsearch data on host machine

```shell
mkdir -p container/elastic/data
```
This is the directory elasticsearch will use to store it's data to avoid data loss between container restarts


From this directory now change to elastic directory

```shell
cd elastic
```

build the elastic container
```shell
docker build -t cgi-elastic:5.2.2 .
```

run the elastic container

```shell
docker run -d --name cgi-elastic-monitor -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -p 9200:9200 -v ~/devops-starter-workshop/pipeline/containers/elastic/data:/usr/share/elasticsearch/data cgi-elastic:5.2.2
```

Run the following command to assert elasicsearch is up

```shell
curl localhost:9200
{
  "name" : "cgi-elastic",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "O_9sov9yQ6a-hh5Tb7quRA",
  "version" : {
    "number" : "5.2.2",
    "build_hash" : "f9d9b74",
    "build_date" : "2017-02-24T17:26:45.835Z",
    "build_snapshot" : false,
    "lucene_version" : "6.4.1"
  },
  "tagline" : "You Know, for Search"
}
```

### Logstash

Switch to the directory ```logstash``` under ```devops-starter-exercise/pipeline/monitoring``` and build the Logstash image

```shell
docker build -t cgi-logstash:5.2.2 .
```

This builds a logstash image with a simple pipeline of reading inputs from the Filebeats plugin and sending output to Elasticsearch

To run the conatiner 

```shell
docker run -itd --name cgi-logstash --link cgi-elastic-monitor:cgi-elastic-monitor cgi-logstash:5.2.2
```

We now have a logstash running with basic pipeline. 


### Kibana

Switch to the ```kibana``` directory under ```devops-starter-exercise/pipeline/monitoring``` and build the Kibana image

```shell
docker build -t cgi-kibana:5.2.2 .
```

To tun this conainter 

```shell
docker run -itd -p 5601:5601 --link cgi-elastic-monitor:cgi-elastic-monitor cgi-kibana:5.2.2
```

You can browse to the Kibana instance through the url [http://localhost:5601]() you'll see the default dashboard.