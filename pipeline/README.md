# Building a pipeline

This section talks about how to build a continuous integration and deployment pipeline using Vagrant, Chef, Docker, ELK Stack & Rundeck

## Before you get started

The code snippets here have been laid out considering a specific directory strcuture and it is important to follow it for the automation to work. Read instructions carefully \m/

Source code used for the app in this example can be found here

[https://github.com/anadimisra/spring-petclinic](https://github.com/anadimisra/spring-petclinic)

It is a simple java app based on spring framework, and uses an in memory database for sake of simplicity.

The exercises a divided into following sections, mapped to folders. follow all the steps under these folders before we get started with a continuous deployment pipeline

1. Setting Up CI > __jenkins-jobs__
2. Using Vagrant + Virtualbox + Docker to spin up base environments > __slave-templates__
3. Using Docker based transversal monitoring solution based on ELK > __monitoring__
4. Using Docker to simplify deployment processes > __jenkins-jobs__


## Continuous deployment pipeline

###Manage environment creation from jenkins

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

### Updating CI Build to do continuous deployment

We now have to update our CI build to so that it can create a docker container fromthe tomcat-filebeat image we created along with latest successful petclinic war file deployed to it.

But before we do that let's add a deploy job, which takes this newly ceated image and starts a named container 

Run the following command from ```pipeline/jenkins-jobs``` directory

```shell
java -jar ../../jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins create-job < cgi-dev-deploy.xml "cgi-dev-deploy"
```
Run the following command from ```pipeline/jenkins-jobs``` directory

```shell
java -jar ../../jenkins/home/cli/jenkins-cli.jar -s http://localhost:8080/jenkins update-job < cgi-ci-build-docker.xml "cgi-ci-build"
```
Trigger a build on CI Job, you will see that it creates a versoioned DEV environment, and then triggers a deploy of this dev environment in the cgi-dev-deploy job.

