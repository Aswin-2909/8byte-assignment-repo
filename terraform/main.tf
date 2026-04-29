# 1. FETCH THE SECRET FROM AWS
# This goes to SSM and finds the parameter you created named "/8byte/db/password"
data "aws_ssm_parameter" "rds_password" {
  name = "/8byte/db/password"
}

# 2. NETWORKING MODULE
module "networking" {
  source               = "./modules/networking"
  name                 = "8byte-aswin"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

# 3. COMPUTE MODULE
module "compute" {
  source    = "./modules/compute"
  name      = "8byte-aswin"
  vpc_id    = module.networking.vpc_id
  subnet_id = module.networking.public_subnet_ids[0] 
}

# 4. DATABASE MODULE (The important part!)
module "database" {
  source           = "./modules/database"
  name             = "8byte-aswin"
  vpc_id           = module.networking.vpc_id
  db_subnet_group  = module.networking.db_subnet_group_name
  app_sg_id        = module.compute.app_sg_id 
  
  # CHANGED: We are passing the value from the SSM Data Source here.
  # We are NO LONGER using var.db_password from your local file.
  db_password      = data.aws_ssm_parameter.rds_password.value
}

# 5. LOAD BALANCER MODULE
module "load_balancer" {
  source         = "./modules/loadbalancer"
  name           = "8byte-aswin"
  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnet_ids
  alb_sg_id      = module.compute.app_sg_id 
}