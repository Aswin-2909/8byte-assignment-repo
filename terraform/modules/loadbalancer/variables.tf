variable "name" {
  description = "Name prefix for the Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the Target Group"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The security group ID to assign to the Load Balancer"
  type        = string
}
