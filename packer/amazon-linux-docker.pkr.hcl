packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon-linux" {
  ami_name          = "academy-linux-docker-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  instance_type     = "t2.micro"
  region            = "us-east-1"
  ssh_username      = "ec2-user"
  ssh_keypair_name  = "vockey"
  ssh_private_key_file = "labsuser.pem"

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.0.*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
}

build {
  name = "amazon-linux-docker"
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]

  provisioner "shell" {
    script = "provision.sh"
  }
}