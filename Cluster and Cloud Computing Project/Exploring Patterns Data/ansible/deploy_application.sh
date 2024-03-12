#!/usr/bin/env bash

. ./group-29-openrc.sh; ansible-playbook deploy_application.yaml -vvv --ask-become-pass -i inventory/application_hosts.ini