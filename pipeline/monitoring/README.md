# Creating a simple monitoring system using ELK stack and Docker

This fodler contains docker recipes to run a ELK based monitoring system. You have to login to the VM created through Jenkins job in order to get this working.

From the git clone root directory move folder containing Vagrant VMs, I created a VM named docker-host and have added it to this git repo for you reference.

```shell
cd pipeline/vagrant-vms/docker-host
vagrant shh
```

You should now be logged in to the VM. Create the following folder strcuture in your home directory

```mkdir -p pipeline/{monitoring/{elastic,kibana,logstash,filebeat},tomcat-filebeat}
```
Start each of the containers in this order.

> __NOTE__: if docker ps -a doesn't work, use sudo instead for all docker commands henceforth

### Elasticsearch

From the home directory create folders for keeping elasticsearch data on host machine

```shell
mkdir -p ~/pipeline/containers/elastic/data
```
This is the directory elasticsearch will use to store it's data to avoid data loss between container restarts


now change to elastic directory

```shell
cd ~/pipeline/monitoring/elastic
```
create the Dockerfile and elasticsearch.yml files

```shell
touch Dockerfile
touch elasticsearch.yml
```
Copy the contents of these two files from the ``` devops-starter-exercise/pipeline/montining/elastic``` directory.

build the elastic container
```shell
docker build -t cgi-elastic:5.2.2 .
```

run the elastic container

```shell
docker run -itd --name cgi-elastic-monitor -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -p 9200:9200 -v ~/pipeline/containers/elastic/data:/usr/share/elasticsearch/data cgi-elastic:5.2.2
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

Switch to the directory ```logstash``` under ```~/pipeline/monitoring``` and create emtry files needed for the build

```shell
touch Dockerfile
mkdir config pipeline
touch config/logj2.properties
touch pipeline/petclinic-tomcat.conf
```
Copy contents from respective files logstash folder of this repository to each of these files. We are now ready to build our logstash docker image. Run the following command from ```~/pipeline/monitoring/logstash``` directory

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

Switch to the ```kibana``` directory under ```~/pipeline/monitoring``` 

Create the build files by copying Dockerfile and kibana.yml from ```monitoring/kibana``` directory of this git repository to this folder and run the docker build

```shell
docker build -t cgi-kibana:5.2.2 .
```
To tun this conainter 

```shell
docker run -itd -p 5601:5601 --link cgi-elastic-monitor:cgi-elastic-monitor cgi-kibana:5.2.2
```

You can browse to the Kibana instance through the url [http://localhost:5601]() you'll see the default dashboard.

You should now move to the exercise under ```devops-starter-exercise/pipeline/tomcat-filebeat``` folder for further steps.