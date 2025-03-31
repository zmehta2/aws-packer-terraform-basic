# Security Group for EC2 Instances
resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  # Allow SSH only from bastion host
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

# Amazon Linux EC2 Instances
resource "aws_instance" "amazon_linux" {
  count                  = var.amazon_linux_count
  ami                    = var.amazon_linux_ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name

  tags = {
    Name = "ec2-amazon-linux-${count.index + 1}"
    OS   = "amazon"
  }
}

# Ubuntu EC2 Instances
resource "aws_instance" "ubuntu" {
  count                  = var.ubuntu_count
  ami                    = var.ubuntu_ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name

  tags = {
    Name = "ec2-ubuntu-${count.index + 1}"
    OS   = "ubuntu"
  }
}

# Ansible Controller Instance
resource "aws_instance" "ansible_controller" {
  ami                    = var.ubuntu_ami_id  # Using Ubuntu for Ansible controller
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name
  user_data              = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y ansible python3-pip
    pip3 install boto3
    echo "Ansible controller setup completed"
  EOF

  tags = {
    Name = "ansible-controller"
  }
}