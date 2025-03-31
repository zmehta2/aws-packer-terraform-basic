#!/bin/bash

# This script is used to set up the Ansible controller EC2 instance
# Execute this script on the Ansible controller after SSH-ing to it

# Update packages
sudo apt-get update
sudo apt-get upgrade -y

# Install Ansible and dependencies
sudo apt-get install -y ansible python3-pip sshpass
sudo pip3 install boto boto3 botocore

# Create ansible directory structure
mkdir -p ~/ansible/group_vars

# Create ansible.cfg
cat > ~/ansible/ansible.cfg << 'EOF'
[defaults]
inventory = ./inventory.ini
host_key_checking = False
remote_user = ec2-user
timeout = 30
log_path = ./ansible.log
EOF

# Copy playbook and inventory from local machine
# This will be done via SCP after creation of the EC2 instances

echo "Ansible controller setup complete."
echo "Next steps:"
echo "1. SCP the inventory.ini, playbook.yml, and ssh_config files to the controller"
echo "2. SSH to the controller"
echo "3. Run the Ansible playbook"