output "amazon_linux_private_ips" {
  description = "Private IPs of the Amazon Linux EC2 instances"
  value       = aws_instance.amazon_linux[*].private_ip
}

output "ubuntu_private_ips" {
  description = "Private IPs of the Ubuntu EC2 instances"
  value       = aws_instance.ubuntu[*].private_ip
}

output "ansible_controller_private_ip" {
  description = "Private IP of the Ansible controller"
  value       = aws_instance.ansible_controller.private_ip
}

output "instance_ids" {
  description = "IDs of all EC2 instances"
  value = concat(
    aws_instance.amazon_linux[*].id,
    aws_instance.ubuntu[*].id,
    [aws_instance.ansible_controller.id]
  )
}

output "all_instances" {
  description = "Information about all EC2 instances for Ansible inventory"
  value = {
    amazon_linux = [
      for instance in aws_instance.amazon_linux : {
        id         = instance.id
        private_ip = instance.private_ip
        public_ip  = instance.public_ip
        tags       = instance.tags
      }
    ]
    ubuntu = [
      for instance in aws_instance.ubuntu : {
        id         = instance.id
        private_ip = instance.private_ip
        public_ip  = instance.public_ip
        tags       = instance.tags
      }
    ]
    ansible_controller = {
      id         = aws_instance.ansible_controller.id
      private_ip = aws_instance.ansible_controller.private_ip
      public_ip  = aws_instance.ansible_controller.public_ip
      tags       = aws_instance.ansible_controller.tags
    }
  }
}