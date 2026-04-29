output "instance_public_ip" {
  value = aws_instance.app_node.public_ip
}

output "app_sg_id" {
  value       = aws_security_group.app_sg.id 
  description = "The ID of the app security group for the DB ingress rule"
}
