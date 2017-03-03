# devops-starter-workshop
A repository with all exercises for building a simple Automated Delivery Pipeline using DevOps Tool-chain

## How to use this repository

Each of the folders have a readme which contains steps from various exercises, follow the README/md in ceach of the directories to refer to exercises.

This Repository has scripts, snippets & configuration etc which allows us creating a build, test, deployment using the following tools

1. Vagrant & Virtualbox for provisioning
2. Infra As Code using Chef
3. Jenkins for Continuous Integration and Deployment Pipeline
4. Rundeck for Job Schdule & Runbook Automation
5. ELK stack for monitoring
6. Docker for Containers

To learn the concepts through this workshop, please follow exercises in the folders in this order

1. __starter__ : this folder has the basics to get you started with basic concpets of Infra Strcuture as code through Chef, Vagrant and Virtualbox
2. __chef-provisioner__ : this folder has the exercises of integrating chef as a provisioner with Vagrant
3. __chef-server__ : an exercise on howto spin up a ready to use Chef Server and Client for your infrastructure
4. __docker-provisioner__ : this folder has basic exercises of docker, along with it's integration to Vagrant as a provider and provisioner
5. __pipeline__: this folder hasa full-fledged continuous deployment pipeline using a combination of Vagrant, Virtualbox, Docker, Chef, Rundeck & ELK Stack
