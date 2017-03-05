# Building a pipeline

This section talks about how to build a continuous integration and deployment pipeline using Vagrant, Chef, Docker, ELK Stack & Rundeck

## Before you get started

The code snippets here have been laid out considering a specific directory strcuture and it is important to follow it for the automation to work. Read instructions carefully \m/

Source code used for the app in this example can be found here

[https://github.com/anadimisra/spring-petclinic](https://github.com/anadimisra/spring-petclinic)

It is a simple java app based on spring framework, and uses an in memory database for sake of simplicity.

The exercises a divided into following sections, whith the code snippets to use for them mapped to the folders where you'll find them

1. Setting up Simple CI environment on HOST Machine > __jenkins-jobs__
2. Using Vagrant + Virtualbox + Jenkins to spin up base environments > __slave-templates__
3. Using Docker based transversal monitoring solution based on ELK > __monitoring__
4. Using Docker to simplify deployment processes > __jenkins-jobs__


### Setting up Simple CI environment on HOST Machine

#### Get Jenkins
Download the latest war package from [Jenkins Website](https://jenkins.io/index.html), choose the latest war from LTS release section in downloads dropdown

#### Get Tomcat
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

#### Running Jenkins 
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


#### Setting up Jenkins CLI jar

From the jenkins home directory create a directory named cli

```shell
cd jenkins/home
mkdir cli
cd cli
```

Download the Jenkins CLI JAR to this location

```shell
curl http://localhost:8080/jenkins/jnlpJars/jenkins-cli.jar -o jenkins-cli-.jar
```

We will be using this CLI JAR for intallation of plugins & automation of slave creation

#### Installing Plugins

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

#### Sample plugin install output

Here's how it should look for a plugin install command

```shell
MacBook-Pro-2:cgi-devops anadi$ java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins install-plugin build-pipeline-plugin -deploy
[WARN] Failed to authenticate with your SSH keys. Proceeding as anonymous
Installing build-pipeline-plugin from update center
MacBook-Pro-2:cgi-devops anadi$
```

#### Creating a simple CI job

From the clone root directory, run the following the command to create a simple CI build for the sample application

```shell
java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins create-job < pipeline/jenkins-jobs/cgi-ci-build.xml "cgi-ci-build"
```

This will create a CI build called cgi-ci-build

Run thebuild to see it complete with success! We are done with our basic jenkins setup.


###Using Vagrant + Virtualbox + Jenkins to spin up base environments

We have created a job template that helps automate spinning up virtual environments using vagrant and virtualbox. __*This job spins up a VM and installs Jenkins SSH slave to it.*__

We'll ad that to Jenkins first. From the repository root switch to jenkins-job directory

```shell
cd pipeline/jenkins-jobs
```

Now run the follwing command to the create the prvisioning job

```shell
java -jar ../../jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins create-job < on-demand-environment.xml "on-demand-environment"
```

This will create a job named on-demand-enviroment. The job takes the following parameters

* __VM_NAME__ : name of the enviroment
* __SSH_PORT__: SSH port to use for port forwarding from host to guest
* __WEB_PORT__: Web server port to use for port forwarding from host to guest
* __TCP_PORT__: Tomcat port to use for port forwarding from host to guest
* __MEMORY__: RAM to allocate to the virtual machine
* __DESCRIPTION__: Description about the slave (*strictly NO SPACES*)
* __EXECUTORS__: Default number of build executors for Jenkins Slave
* __SLAVE_HOST__: host to connect to the Jenkins slave
* __SLAVE_LABEL__: A label to group similar slaves (tagging)

Run the build with values of your choice. This should 

* create a VM, with Docker and Java installed & configured
* create a jenkins slave with the same name as VM_NAME
* connec to the the VM, setup jenkins slave and start it

Now that we have this environment running we will use for the exercises in point 3 & 4 mentioed in section __Before you get started__. This build creates an environment under the ```devops-starter-exercise/pipeline/vagrant-vms/$VM_NAME``` directory.

From ```devops-starter-exercise/pipeline/vagrant-vms/$VM_NAME``` directory login to the VM

```shell
vagrant ssh
```

Check if deocker is running

```shell
docker ps -a
```

> You might have to use sudo in some cases, depends on the Ubuntu versions you choose.

You shouldn't get any containers as response at this point. 

Move to the exercises under __monitoring__ & __tomcat-filebeat__ folders to setup Docker containers inside the VMs.

## Continuous deployment pipeline

Logout of the Vagrant VM and run these commands from your host machine.

### Updating CI Build to do continuous deployment

We now have to update our CI build to so that it can create a docker container fromthe tomcat-filebeat image we created along with latest successful petclinic war file deployed to it.

But before we do that let's add a deploy job, which takes this newly ceated image and starts a named container 

Run the following command from clone root directory

```shell
java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins create-job < pipeline/jenkins-jobs/cgi-dev-deploy.xml "cgi-dev-deploy"
```
This creates a simple deploy job which

* stops any previous version of the Dev Environment running
* removes the container stopped in previous step
* starts a new container which is our new dev environment deployed with bleeding edge version of our application

Now run the following command from from clone root directory

```shell
java -jar jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins update-job < pipeline/jenkins/jobs/cgi-ci-build-docker.xml "cgi-ci-build"
```
This updates our simple CI build to add following steps

* build a new Docker image from the Tomcat-Filebeat image we just created, and add latest built petclinic WAR to it, tag with the dev-$BUILD_NUMBER, hence we get versioned environments!
* trigger a new deployment job for this image (cgi-dev-deploy)

#### Move cgi-ci-build & cgi-dev-deploy to slave
Since our docker containers are all inside the VM we have to move these jobs to run within the Jenkins slave we created as a pre-step to building the pipeline. 

Go to the configure page of both these builds and choose the option __"Restrict where this job can run"__ enter the name Vagrant VM you created and save the job.

Trigger a build on CI Job, you will see that it creates a versoioned DEV environment, and then triggers a deploy of this dev environment in the cgi-dev-deploy job.

