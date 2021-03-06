#!/bin/bash

# Update all packages that have available updates.
sudo apt-get update

# Install Python 3 and pip.
sudo apt-get install python3-pip

# Upgrade pip3.
sudo pip3 install --upgrade pip

# Install Ansible.
pip3 install "ansible==2.9.17"
sudo apt install ansible
sudo apt upgrade -y 
# Install Ansible azure_rm module for interacting with Azure.
pip3 install ansible[azure]