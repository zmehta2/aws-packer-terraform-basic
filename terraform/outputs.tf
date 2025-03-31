output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "bastion_ip" {
  description = "Public IP of the bastion host"
  value       = module.bastion.bastion_ip
}

output "amazon_linux_private_ips" {
  description = "Private IPs of the Amazon Linux EC2 instances"
  value       = module.ec2_instances.amazon_linux_private_ips
}

output "ubuntu_private_ips" {
  description = "Private IPs of the Ubuntu EC2 instances"
  value       = module.ec2_instances.ubuntu_private_ips
}

output "ansible_controller_private_ip" {
  description = "Private IP of the Ansible controller"
  value       = module.ec2_instances.ansible_controller_private_ip
}

output "ssh_bastion_command" {
  description = "SSH command to connect to the bastion host"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.bastion.bastion_ip}"
}

output "all_instances_info" {
  description = "Information about all instances"
  value       = module.ec2_instances.all_instances
}