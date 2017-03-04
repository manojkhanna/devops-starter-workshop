# Building a pipeline

This section talks about how to build a continuous integration and deployment pipeline using Vagrant, Chef, Docker, ELK Stack & Rundeck

## Before you get started

The code snippets here have been laid out considering a specific directory strcuture and it is important to follow it for the automation to work. Read instructions carefully \m/

Source code used for the app in this example can be found here

[https://github.com/anadimisra/spring-petclinic](https://github.com/anadimisra/spring-petclinic)

It is a simple java app based on spring framework, and uses an in memory database for sake of simplicity.

The exercises a divided into following sections, mapped to folders

1. Setting Up CI > __jenkins-jobs__
2. Using Vagrant + Virtualbox + Docker to spin up base environments > __slave-templates__
3. Using Docker based transversal monitoring solution based on ELK > __monitoring__
4. Using Docker to simplify deployment processes > __jenkins-jobs__
5. Using ELK Stack for adding monitoring as a service for all environments > __monitoring__


