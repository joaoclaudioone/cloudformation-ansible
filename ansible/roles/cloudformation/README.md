VPC
=========

Role that create a vpc stack on cloudformation.

Requirements
------------

An AWS account 

Role Variables
--------------

This role depends that this variables has some Values
stack_name
state
email
keyname
imageid
instancetype
alb_listener_port
alb_tg_port
app_port
vpc_stack
vpccidr

Example Playbook
----------------

This role is used with a playbook passing the Variables
- hosts: localhost
  vars:
    stack_name: "{{ stack_name }}"
    state: "{{ state }}"
    email: "{{ email }}"

License
-------

BSD
