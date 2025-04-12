output "bridge_instance_public_ip" {
  description = "Publiczny adres IP instancji bridge (EC2)"
  value       = aws_instance.bridge_ec2.public_ip
}

output "bridge_subnet_id" {
  description = "ID utworzonego subnetu dla bridge"
  value       = aws_subnet.bridge_subnet.id
}

output "bridge_security_group_id" {
  description = "ID Security Group utworzonej dla instancji bridge"
  value       = aws_security_group.bridge_sg.id
}
