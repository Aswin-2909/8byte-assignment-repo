# --- 1. DATA SOURCES ---
# Fetches the RDS password from SSM Parameter Store
data "aws_ssm_parameter" "rds_password" {
  name = "/8byte/db/password"
}

# --- 2. NETWORKING ---
module "networking" {
  source               = "./modules/networking"
  name                 = "8byte-aswin"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

# --- 3. COMPUTE ---
module "compute" {
  source    = "./modules/compute"
  name      = "8byte-aswin"
  vpc_id    = module.networking.vpc_id
  subnet_id = module.networking.public_subnet_ids[0] 
}

# --- 4. DATABASE ---
module "database" {
  source           = "./modules/database" # Verified path from your explorer
  name             = "8byte-aswin"
  vpc_id           = module.networking.vpc_id
  db_subnet_group  = module.networking.db_subnet_group_name
  app_sg_id        = module.compute.app_sg_id 
  
  # Uses the SSM parameter fetched at the top of this file
  db_password      = data.aws_ssm_parameter.rds_password.value
}

# --- 5. LOAD BALANCER ---
module "load_balancer" {
  source         = "./modules/loadbalancer"
  name           = "8byte-aswin"
  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnet_ids
  alb_sg_id      = module.compute.app_sg_id 
}