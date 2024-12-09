#!/bin/bash
terraform init && terraform apply -auto-approve && ansible-playbook 01.configure-VMsOS.yaml --tags all
