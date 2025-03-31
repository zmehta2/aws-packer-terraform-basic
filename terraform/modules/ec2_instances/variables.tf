variable "amazon_linux_ami_id" {
  description = "AMI ID for Amazon Linux EC2 instances"
  type        = string
}

variable "ubuntu_ami_id" {
  description = "AMI ID for Ubuntu EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EC2 instances"
  type        = list(string)
}

variable "bastion_sg_id" {
  description = "Security group ID of the bastion host"
  type        = string
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "amazon_linux_count" {
  description = "Number of Amazon Linux EC2 instances to create"
  type        = number
  default     = 3
}

variable "ubuntu_count" {
  description = "Number of Ubuntu EC2 instances to create"
  type        = number
  default     = 3
}