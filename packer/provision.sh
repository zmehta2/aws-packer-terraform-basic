#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo yum update -y

# Install Docker
echo "Installing Docker..."
sudo amazon-linux-extras install docker -y

# Start and enable Docker service
echo "Configuring Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Add ec2-user to the docker group
echo "Adding ec2-user to docker group..."
sudo usermod -aG docker ec2-user

# Install other useful tools
echo "Installing additional tools..."
sudo yum install -y git jq

# Print Docker version for verification
echo "Docker installation complete. Version information:"
sudo docker --version

echo "AMI provisioning completed successfully!"