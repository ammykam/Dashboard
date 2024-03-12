#!/bin/bash
ansible-galaxy collection install openstack.cloud:2.0.0

. ./group-29-openrc.sh; ansible-playbook -vvv deploy_instances.yaml --ask-become-pass