variable "name" {
  description = "Name prefix for the resources"
  type        = string
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true 
}