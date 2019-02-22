deploy
=========

This role do some tasks that prepare an ami for deploying a java application.

Requirements
------------

An AWS account

Role Variables
--------------

app_group_adm
app_user_adm
pv_device


Example Playbook
----------------

- hosts: all
  become: yes
  vars:
    app_name: "{{ keyname }}"
    app_origin: "{{ app_origin }}"

License
-------

BSD
