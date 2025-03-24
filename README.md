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

<img width="1259" alt="Screenshot 2025-03-24 at 1 20 10 PM" src="https://github.com/user-attachments/assets/8ef7982a-7f97-4e3e-b5a1-4b088b6e1701" />

<img width="1077" alt="Screenshot 2025-03-24 at 1 20 22 PM" src="https://github.com/user-attachments/assets/79ef143a-7b83-4701-a3aa-12b8410cc729" />

### Terraform Apply

![Terraform Apply](screenshots/terraform-apply.png)

### SSH to Bastion Host

![SSH to Bastion Host](screenshots/ssh-bastion.png)

### SSH to Private EC2 Instance

![SSH to EC2 Instance](screenshots/ssh-ec2.png)

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
