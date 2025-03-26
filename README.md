# AWS Infrastructure Provisioning Project

This project demonstrates how to create a custom AWS AMI using Packer and provision AWS infrastructure using Terraform.

## Project Overview

The infrastructure consists of:

- A VPC with private and public subnets
- A bastion host in a public subnet for secure SSH access
- 6 EC2 instances in private subnets, accessible only through the bastion host
- All EC2 instances use a custom AMI built with Packer that includes Amazon Linux and Docker

## Prerequisites

- AWS Account (AWS Academy)
- Packer
- Terraform
- AWS CLI
- SSH key pair

## Project Structure

```
.
├── README.md
├── packer/
│   └── amazon-linux-docker.pkr.hcl
└── terraform/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── modules/
    │   ├── vpc/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   ├── bastion/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   └── ec2_instances/
    │       ├── main.tf
    │       ├── variables.tf
    │       └── outputs.tf
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/zmehta2/aws-packer-terraform-basic.git
cd aws-infrastructure-project
```

### 2. Generate SSH Key Pair

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/aws-key
```

### 3. Build the Custom AMI with Packer

```bash
cd packer
packer init .
packer build amazon-linux-docker.pkr.hcl
```

Take note of the AMI ID that Packer outputs after building.

### 4. Update Terraform Variables

Edit `terraform/variables.tf` and update the `custom_ami_id` variable with the AMI ID from the previous step.

### 5. Deploy the Infrastructure with Terraform

```bash
cd ../terraform
terraform init
terraform plan
terraform apply
```

## Accessing the Infrastructure

After Terraform successfully provisions the infrastructure, it will output the public IP of the bastion host and a ready-to-use SSH command.

1. SSH into the bastion host:

```bash
ssh -i ~/.ssh/aws-key ec2-user@<bastion-public-ip>
```

2. From the bastion host, SSH into any EC2 instance:

```bash
ssh -i ~/.ssh/aws-key ec2-user@<ec2-private-ip>
```

## Screenshots

### Packer Build

<img width="1077" alt="Screenshot 2025-03-24 at 1 20 22 PM" src="https://github.com/user-attachments/assets/79ef143a-7b83-4701-a3aa-12b8410cc729" />

### Terraform Apply

<img width="737" alt="Screenshot 2025-03-26 at 1 53 03 AM" src="https://github.com/user-attachments/assets/87d00734-b2c8-4c0f-97b5-5f6b8bcb31de" />

### VPC

<img width="1698" alt="Screenshot 2025-03-26 at 1 56 11 AM" src="https://github.com/user-attachments/assets/5118921d-173f-4cb3-b6b3-089efe3b7ada" />

<img width="1710" alt="Screenshot 2025-03-26 at 1 51 42 AM" src="https://github.com/user-attachments/assets/5f8e163a-531b-459c-a225-ba588012555d" />

## Private subnet is connected to the internet through a NAT Gateway

<img width="1415" alt="Screenshot 2025-03-26 at 1 58 14 AM" src="https://github.com/user-attachments/assets/e2334ea8-8cc1-4537-b596-ba3fe75047fa" />

## Public subnet connected to internet through Internet Gateway

<img width="1400" alt="Screenshot 2025-03-26 at 1 59 38 AM" src="https://github.com/user-attachments/assets/183c04cb-4e60-4dc2-9f6d-340b7677568b" />

## Internet Gateways

<img width="1448" alt="Screenshot 2025-03-26 at 2 07 25 AM" src="https://github.com/user-attachments/assets/f8ce4dae-f98e-4da4-99b8-54c870fab33d" />

## Elastic IPs

<img width="1428" alt="Screenshot 2025-03-26 at 2 08 37 AM" src="https://github.com/user-attachments/assets/af94368b-3d4c-42b2-bd49-debbe3322f8f" />

## NAT gateways 

<img width="1442" alt="Screenshot 2025-03-26 at 2 10 10 AM" src="https://github.com/user-attachments/assets/58b985bd-37cb-4545-8ed3-367ccb73b50a" />

## Cleaning Up

To destroy the infrastructure when you're done:

```bash
cd terraform
terraform destroy
```

## Notes

- The bastion host security group only allows SSH access from your IP address.
- EC2 instances in private subnets can only be accessed through the bastion host.
- All EC2 instances have Docker installed and configured.
