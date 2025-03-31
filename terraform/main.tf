provider "aws" {
  region  = "us-east-1"
}

# Get your public IP for bastion host security group
data "http" "myip" {
  url = "https://api.ipify.org"
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# Bastion Host Module
module "bastion" {
  source = "./modules/bastion"

  ami_id              = var.bastion_ami_id
  instance_type       = var.bastion_instance_type
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.public_subnet_ids[0]
  my_ip               = "${chomp(data.http.myip.response_body)}/32"
  key_name            = var.key_name
}

# EC2 Instances Module
module "ec2_instances" {
  source = "./modules/ec2_instances"

  amazon_linux_ami_id = var.amazon_linux_ami_id
  ubuntu_ami_id       = var.ubuntu_ami_id
  instance_type       = var.ec2_instance_type
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  bastion_sg_id       = module.bastion.security_group_id
  key_name            = var.key_name
  amazon_linux_count  = 3
  ubuntu_count        = 3
}

# Generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  content = templatefile("./templates/inventory.tmpl", {
    amazon_linux_hosts = module.ec2_instances.amazon_linux_private_ips,
    ubuntu_hosts       = module.ec2_instances.ubuntu_private_ips,
    ansible_controller = module.ec2_instances.ansible_controller_private_ip,
    ssh_key_path       = "~/.ssh/${var.key_name}.pem"
  })
  filename = "./ansible/inventory.ini"
}

# Generate SSH config file for easier access through bastion
resource "local_file" "ssh_config" {
  content = templatefile("./templates/ssh_config.tmpl", {
    bastion_ip  = module.bastion.bastion_ip,
    key_path    = "~/.ssh/${var.key_name}.pem",
    private_ips = concat(
      module.ec2_instances.amazon_linux_private_ips,
      module.ec2_instances.ubuntu_private_ips,
      [module.ec2_instances.ansible_controller_private_ip]
    )
  })
  filename = "./ansible/ssh_config"
}