provider "aws" {
  region = var.region
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

  ami_id              = var.custom_ami_id
  instance_type       = var.ec2_instance_type
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  bastion_sg_id       = module.bastion.security_group_id
  key_name            = var.key_name
  instance_count      = 2
}