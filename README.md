Deploy applications
=========

This repository has a package of scripts to deploy an application in AWS using Clouformation stacks.
I choosed to use ansible to manage the cloudformation templates, because I think would be easyer than using awscli
A Makefile is a easy and powerful tool to orchestrate this process. You can add options faster and accept external parameters


Requirements
------------

You will need for that this packages:
- ansible
- aws cli
``pip install -r requirements.txt``

- packer 1.3.4, that is provided inside the root directory

Usage
-----

The Makefile in the root of repository helps creating a vpc, autoscaling group and ssh keys. All configuration are stored in the vars directory, create a file with all configuration and the scritpt will run.

The command make deploy all environment

``make -e PROJECT=<project> VERSION=<version>``

It's possible to create and update the launch configuration with  make deploy

``make -e PROJECT=<project> VERSION=<version>``
