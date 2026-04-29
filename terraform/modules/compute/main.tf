# Generate Private Key
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# AWS Key Pair
resource "aws_key_pair" "app_key" {
  key_name   = "${var.name}-key"
  public_key = tls_private_key.main.public_key_openssh
}

# Save .pem file locally
resource "local_file" "ssh_key" {
  filename        = "${path.root}/${var.name}-key.pem"
  content         = tls_private_key.main.private_key_pem
  file_permission = "0400"
}

# Security Group
resource "aws_security_group" "app_sg" {
  name   = "${var.name}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EC2 Instance
resource "aws_instance" "app_node" {
  ami                         = var.ami_id
  instance_type               = "t3.small"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = aws_key_pair.app_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.name}-server"
  }
}