output "final_vpc_id" {
  value = module.networking.vpc_id
}

output "final_nat_ips" {
  value = module.networking.nat_public_ips
}

output "app_server_ip" {
  value = module.compute.instance_public_ip 
}

output "database_endpoint" {
  value = module.database.db_instance_endpoint
}

output "db_hostname" {
  description = "RDS Connection Endpoint"
  value       = module.database.db_instance_endpoint
}

output "load_balancer_url" {
  description = "The Public URL for the 8Byte App"
  # Note the underscore here to match your main.tf line 26
  value       = module.load_balancer.alb_dns_name 
}

output "ec2_public_ip" {
  description = "Public IP of the App Server"
  value       = module.compute.instance_public_ip
}