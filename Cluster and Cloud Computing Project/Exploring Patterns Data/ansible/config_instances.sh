#!/usr/bin/env bash

. ./group-29-openrc.sh; ansible-playbook --ask-become-pass  config_instances.yaml -i inventory/application_hosts.ini