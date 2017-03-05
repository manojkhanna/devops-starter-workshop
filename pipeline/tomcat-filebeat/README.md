# Creating and Tomcat and Filebeat image

### Building the container to be used as template for all environments

Since our pipeline runs on docker containers, we want to use an image which comes up with setting required to ship logs to Elasticsearch through Logstash. That was we do not have to worry mounting host folders for preserving logs. This guide leads you through the steps for that.

The Dockerfile contains recipe for building a container that runs both tomcat and filebeat managed through supervisor that we learnt in docker basics exercise. 

Switch to ```~/pipeline/tomcat-filebeat``` folder

Copy files from the ```devops-starter-exercise/pipeline/tomcat-filebeat``` folder to this directory to build the docker container 

```shell
docker build -t cgi-petclinic:jre8-filebeat5.2.2 .
```

This container will serve as base image for all deployments. Check if image is available 

```shell
docker images
REPOSITORY                                      TAG                  IMAGE ID            CREATED             SIZE
cgi-petclinic                                   jre8-filebeat5.2.2   bccb526fb69a        2 hours ago         445 MB
cgi-kibana                                      5.2.2                d6e6816044be        2 hours ago         674 MB
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

### Building the first version of our Dev Environment

Open the jenkins CI build we created earlier in the browser of your host VM

[http://localhost:8080/jenkins/cgi-ci-build]() brwose to the workspace and download ```target/petclinic.war``` file and the ```Dockerfile```

Now from within the vagrant vm terminal create a directory 

```shell
mkdir ~/petclinic
```

Copy the war file and Dockerfile to this directory inside the VM. You can use ```scp``` command from you host machine terminal or use Winscp on windows.

In the end your ```~/petclinic``` directory under the VM should have these files 

```shell
petclinic.war
Dockerfile
```

Now lets build our first version of the environment
```shell
docker build -t cgi-petclinic:dev-1
```
the tag dev-1 has a purpose, __dev__ represents that this is the dev environment, while 1 isthe build number of the Jenkins build that created the petclinic war, later on this value will be passed through a paramater named ```$CONTAINER_TAG``` when we automate the process.

Once the build is done, run this docker container 

```shell
docker run -itd --name cgi-petclinic-dev -p 8989:8080 cgi-petclinic:dev-1
```

From you host machine, browse to [http://localhost:8989/petclinic](), you should be able to access the Petclinic home page.

Voila! we have our first version of Dev environment deployed and running ;-) time to move all of it as an automated pipeline using Jenkins.