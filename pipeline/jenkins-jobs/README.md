# Setup a CI Environment using Jenkins

For the sake of simplicity we will run Jenkins in the host machine, this exercise uides you through setup of Jenkins with all relevant steaps.

## CI Setup

### Get Jenkins
Download the latest war package from [Jenkins Website](https://jenkins.io/index.html), choose the latest war from LTS release section in downloads dropdown

### Get Tomcat

Download the latest stable version of Tomcat 8.5.X from [this url](http://tomcat.apache.org/download-80.cgi)

> You could have taken Jetty or any other similar application server, doesn't really matter

from the __root directory of this repository clone__ create a directory called jenkins, i.e. if you are in this folder, i.e. __[ROOT]__/pipeline/jenkins-jobs then

```shell
cd ../../
mkdir jenkins
cd jenkins
```

explode downloaded tomcat here and add a ```setenv.sh``` or ```setenv.bat``` for windows to the ```apache-tomcat-XXX/bin``` directory with following contents

```shell
#!/bin/bash
# Set tomcat container and Jenkins environment variables
JAVA_HOME=[POINT TO YOUR JDK INSTALLATION HERE]
# On my mac it is /Library/Java/JavaVirtualMachines/jdk1.8.0_72.jdk/Contents/Home
JRE_HOME=$JAVA_HOME/jre
CATALINA_PID=$CATALINA_HOME/bin/catalina.pid
JAVA_OPTS="-server -Xmx256m -Djava.awt.headless=true -Dhudson.DNSMultiCast.disabled=true -Dhudson.util.ProcessTree.disable=true -DJENKINS_HOME=[POINT TO ROOT OF THIS REPOSITORY CLONE]/jenkins/home"
```

> ignore the shebang #!/bin/bash on windows

### Running Jenkins 
from root of git repository clone, create jenkins/home directory if does not exist

```shell
mkdir -p jenkins/home
```
> for future reference we will call this directory JENKINS_HOME

Copy Jenkins WAR to the tomcat webapp directory

```shell
cp ~/Downloads/jenkins.war jenkins/apache-tomcat-8.5.11/webapps/
```

Start the container

```shell
sh jenkins/apache-tomcat-8.5.11/bin/startup.sh ; tail -f jenkins/apache-tomcat-8.5.11/logs/catalina.out
```
Or on windows

```
jenkins/apache-tomcat-8.5.11/bin/startup.bat
```

Navigate to jenkins homepage through URL 

[http://localhost:8080/jenkins]()

do the inital setup, and Go to Jenkins > Manage Jenkins > Configure Security and disable securty completely, we do not need it for the purpose of this demo.


### Setting up Jenkins CLI jar

From the jenkins home directory create a directory named cli

```shell
cd jenkins/home
mkdir cli
cd cli
```

Download the Jenkins CLI JAR to this location

```shell
curl -o http://localhost:8080/jenkins/jnlpJars/jenkins-cli.jar
```

We will be using this CLI JAR for intallation of plugins & automation of slave creation

### Installing Plugins

From the clone root directory, run the following commands to ensure we havethe right set of plugins needed for our pipeline

```shell

java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin build-pipeline-plugin -deploy

java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin copyartifact -deploy

java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin conditional-buildstep -deploy

java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin docker-plugin -deploy

java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin docker-build-step -deploy

java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin parameterized-trigger -deploy

java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin timestamper -deploy

java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin vagrant -deploy
```

__Sample plugin install output__

Here's how it should look for a plugin install command

```shell
MacBook-Pro-2:cgi-devops anadi$ java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin build-pipeline-plugin -deploy
[WARN] Failed to authenticate with your SSH keys. Proceeding as anonymous
Installing build-pipeline-plugin from update center
MacBook-Pro-2:cgi-devops anadi$
```

### Creating a simple CI job

From the clone root directory, run the following the command to create a simple CI build for the sample application

```shell
java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins create-job < pipeline/jenkins-jobs/cgi-ci-build.xml "cgi-ci-build"
```

This will create a CI build called cgi-ci-build

Run thebuild to see it complete with success! We are done with our basic jenkins setup.


