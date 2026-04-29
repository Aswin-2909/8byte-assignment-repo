# 1. Security Group for the Database
resource "aws_security_group" "db_sg" {
  name   = "${var.name}-db-sg"
  vpc_id = var.vpc_id

  # INGRESS: Allow the App Server (EC2) to talk to the DB
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  # EGRESS: Allow the DB to send data back out (Crucial for updates/replies)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. The PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro" # Free Tier eligible
  db_name                = "eightbyte_db"
  username               = "dbadmin"
  password               = var.db_password
  db_subnet_group_name   = var.db_subnet_group
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false # Keeps it inside your private subnets
}