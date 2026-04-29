variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "ami_id" {
  type    = string
  default = "ami-0c7217cdde317cfec" # Ubuntu 22.04 in us-east-1
}