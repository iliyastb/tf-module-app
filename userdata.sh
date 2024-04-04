#!/bin/bash
ls
#ansible-pull -i localhost, -U https://github.com/iliyastb/robsohop-ansible.git roboshop.yml -e role_name=${component} -e env=${env} >/opt/ansible.log