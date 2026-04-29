# --- DATA SOURCES ---
# Fetches the password from AWS SSM Parameter Store (Secret Management)
data "aws_ssm_parameter" "rds_password" {
  name = "/8byte/db/password"
}

# --- SECURITY GROUPS ---
# Database Security Group: Restricts access to only the App Server
resource "aws_security_group" "db_sg" {
  name        = "${var.name}-db-sg"
  description = "Allow inbound traffic from the application tier only"
  vpc_id      = var.vpc_id

  # INGRESS: Allow PostgreSQL traffic (5432) only from the App Security Group
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  # EGRESS: Standard outbound traffic rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-db-sg"
  }
}

# --- RDS INSTANCE ---
# PostgreSQL Instance with automated backups and secure credentials
resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  max_allocated_storage  = 100 # Allows for storage autoscaling (Best Practice)
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro" # Free Tier Eligible
  db_name                = "eightbyte_db"
  username               = "dbadmin"
  
  # SECRET MANAGEMENT: Pulls password from SSM to avoid hardcoding in Git
  password               = data.aws_ssm_parameter.rds_password.value
  
  db_subnet_group_name   = var.db_subnet_group
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  # BACKUP STRATEGY: 7-day retention period for point-in-time recovery
  backup_retention_period = 7
  backup_window           = "03:00-04:00" # Daily backup window (UTC)
  maintenance_window      = "Mon:04:00-Mon:05:00"

  # SECURITY: Private database, not accessible from the internet
  publicly_accessible     = false
  skip_final_snapshot     = true
  storage_encrypted       = true # Encrypts data at rest

  tags = {
    Name = "${var.name}-rds-instance"
  }
}