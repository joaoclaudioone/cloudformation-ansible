Deploy applications
=========

This repository has a package of scripts to deploy an application in AWS using Clouformation stacks.

Requirements
------------

You will need for that this packages:
- ansible
``pip install -r requirements.txt``

- packer 1.3.4, that is provided inside the ami directory

Usage
-----

The Makefile in the root of repository helps creating a vpc, autoscaling group and ssh keys.
In ami directory its possible creating an ami with the jar embedded. 
