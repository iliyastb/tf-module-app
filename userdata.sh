#!/bin/bash

ansible-pull -i localhost, -U https://github.com/iliyastb/roboshop-ansible.git roboshop.yml -e role_name=${component} -e env=${env} >/opt/ansible.log