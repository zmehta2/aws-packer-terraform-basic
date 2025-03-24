output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "bastion_ip" {
  description = "Public IP of the bastion host"
  value       = module.bastion.bastion_ip
}

output "ec2_private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = module.ec2_instances.private_ips
}

output "connection_string" {
  description = "SSH connection string to bastion host"
  value       = "ssh -i ~/.ssh/aws-key ec2-user@${module.bastion.bastion_ip}"
}