output "private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = aws_instance.ec2[*].private_ip
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.ec2[*].id
}