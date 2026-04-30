8Byte DevOps Infrastructure & CI/CD Pipeline
This repository contains the infrastructure automation and continuous integration/continuous deployment (CI/CD) pipeline for the 8Byte technical assignment. The project provisions cloud infrastructure on AWS and automates the deployment of a containerized application.

⚙️ 1. How to Set Up and Run the Infrastructure
Prerequisites
AWS CLI installed and configured with appropriate IAM permissions.

Terraform (v1.0+) installed locally.

A DockerHub account for image hosting.

A GitHub account with the repository set to Public to enable Environment Protection Rules.

Step 1: Provision Infrastructure (Terraform)
The infrastructure is defined as code using Terraform to ensure repeatability.

Navigate to the terraform/ directory.

Initialize the working directory:

Bash
terraform init
Review the execution plan:

Bash
terraform plan
Apply the configuration to provision the VPC, EC2 instance, and RDS database:

Bash
terraform apply -auto-approve
Step 2: Configure GitHub Secrets & Environments
To allow the CI/CD pipeline to access the infrastructure, configure the following in your GitHub repository:

Repository Secrets (Settings > Secrets and variables > Actions):

DOCKERHUB_USERNAME & DOCKERHUB_TOKEN

STAGING_EC2_HOST & EC2_SSH_KEY

STAGING_DB_HOST & DB_PASSWORD

MAIL_USERNAME & MAIL_PASSWORD (For failure notifications)

Environment Settings (Crucial for the Manual Gate):

Go to Settings > Environments and create an environment named exactly production.

Check the Required reviewers box and add your GitHub username.

Add these secrets specifically to this environment: EC2_HOST and DB_HOST.

🏗️ 2. Architecture Decisions
Decoupled Database: Used Amazon RDS for PostgreSQL instead of hosting the database inside a Docker container. This ensures data persistence independent of the application lifecycle and offloads management overhead.

Single-Server Multi-Environment: For this assignment, both Staging and Production containers share a single EC2 instance to optimize resources.

CI/CD Tooling: Chose GitHub Actions over Jenkins to provide native, low-friction integration with the source code without requiring a dedicated CI server to manage.

🛡️ 3. Security Considerations ("Shift-Left" Approach)
Vulnerability Scanning: Integrated Trivy into the workflow. The pipeline automatically fails and blocks deployment if CRITICAL or HIGH vulnerabilities are detected.

Manual Deployment Gate: Production deployments are fenced using GitHub Environments. The pipeline physically pauses and requires explicit, manual approval before the app is exposed on Port 80.

Secret Management: No sensitive data is hardcoded. All credentials (passwords, IP addresses, SSH keys) are injected at runtime via GitHub Encrypted Secrets.

Port Isolation: Implemented fuser logic and Docker network pruning during deployment to ensure that staging and production containers do not conflict or expose unauthorized ports.

💰 4. Cost Optimization Measures
Consolidated Compute: By routing both Staging (Port 8080) and Production (Port 80) traffic to a single EC2 instance, compute costs are effectively halved.

Right-Sized Instances: The infrastructure utilizes t2.micro or t3.micro instance types, which are suitable for lightweight Node.js workloads without over-provisioning.

Egress Cost Reduction: The Docker image is built on the GitHub Actions runner rather than pulling heavy base images directly onto the EC2 instance, minimizing AWS data transfer charges.

🛠️ How to Access
Staging Environment: http://<EC2-Public-IP>:8080

Production Environment: http://<EC2-Public-IP>:80

Author: Aswin Ramesh