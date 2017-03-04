# Creating and Tomcat and Filebeat image

Since our pipeline runs on docker containers, we want to use an image which comes up with setting required to ship logs to Elasticsearch through Logstash. That was we do not have to worry mounting host folders for preserving logs. This guide leads you through the steps for that.

The Dockerfile contains recipe for building a container that runs both tomcat and filebeat managed through supervisor that we learnt in docker basics exercise. 

Switch to ```tomcat-filebeat``` container from ```devops-starter-exercise/pipeline``` folder

Build the docker container 

```shell
docker build -t cgi-petclinic:jre8-filebeat5.2.2 .
```

This container will serve as base image for all deployments. Check if image is available 

```shell
docker images
REPOSITORY                                      TAG                  IMAGE ID            CREATED             SIZE
cgi-petclinic                                   jre8-filebeat5.2.2   bccb526fb69a        2 hours ago       445 MB
cgi-kibana                                      5.2.2                d6e6816044be        2 hours ago   674 MB
cgi-logstash                                    5.2.2                be6942ca0f7d        4 hours ago         542 MB
cgi-elastic                                     5.2.2                c2ce3d71e787        7 hours ago         206 MB
tomcat                                          9.0.0-jre8           bd895bfb6a18        3 days ago          365 MB
openjdk                                         8-jre                a4d689e63201        4 days ago          309 MB
docker.elastic.co/logstash/logstash             5.2.2                eb145c1bfb1d        4 days ago          545 MB
docker.elastic.co/kibana/kibana                 5.2.2                632182dfaaf7        4 days ago          674 MB
docker.elastic.co/elasticsearch/elasticsearch   5.2.2                89315294a341        4 days ago          206 MB
ubuntu                                          16.04                0ef2e08ed3fa        4 days ago          130 MB
```

your image cgi-petclinic should be availabe in the list.
