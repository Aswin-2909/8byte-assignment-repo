variable "name" {
  description = "Name prefix for the resources"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the DB will live"
  type        = string
}

variable "db_subnet_group" {
  description = "The DB subnet group name created in the networking module"
  type        = string
}

variable "app_sg_id" {
  description = "The Security Group ID of the App Server to allow access"
  type        = string
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true # This hides the password from the terminal logs
}



