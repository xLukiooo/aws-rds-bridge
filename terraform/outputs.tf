output "bridge_instance_id" {
  description = "ID utworzonej instancji EC2 (Bridge)"
  value       = aws_instance.bridge_ec2.id
}

output "bridge_security_group_id" {
  description = "ID Security Group instancji bridge (Zero-Trust SG)"
  value       = aws_security_group.bridge_sg.id
}

output "bridge_subnet_id" {
  description = "ID podsieci, w której działa bridge"
  value       = aws_subnet.bridge_subnet.id
}

output "ssm_port_forward_command" {
  description = "Polecenie CLI do zestawienia bezpiecznego tunelu SSM z lokalnego komputera do bazy RDS"
  value       = "aws ssm start-session --target ${aws_instance.bridge_ec2.id} --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{\"host\":[\"${var.rds_endpoint}\"],\"portNumber\":[\"${tostring(var.db_port)}\"],\"localPortNumber\":[\"${tostring(var.local_port)}\"]}'"
}

output "interactive_shell_command" {
  description = "Polecenie CLI do otwarcia bezpiecznej powłoki na instancji bridge (bez SSH)"
  value       = "aws ssm start-session --target ${aws_instance.bridge_ec2.id}"
}

output "local_connection_example" {
  description = "Przykładowe polecenie połączenia do lokalnego punktu końcowego po zestawieniu tunelu"
  value       = var.db_port == 5432 ? "psql -h 127.0.0.1 -p ${var.local_port} -U <db_user> -d <db_name>" : "mysql -h 127.0.0.1 -P ${var.local_port} -u <db_user> -p"
}
