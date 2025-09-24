# This file contains example Terraform infrastructure for Datadog tagging compliance demo
# Some resources are compliant with Datadog tagging policies, others are not
# This demonstrates how IaC scanning can catch non-compliant resources before deployment
# 
# Required Datadog tags: env, service, version, team
# These tags enable seamless navigation in Datadog UI, Watchdog, APM, Logs, RUM, and K8s monitoring

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ✅ DATADOG COMPLIANT RESOURCE: Has all required Datadog tags
resource "aws_instance" "web_server_compliant" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  
  tags = {
    Name        = "web-server-prod"
    # Required Datadog tags for observability
    env         = "prod"
    service     = "web-server"
    version     = "1.2.3"
    team        = "platform-team"
    
    # Optional but helpful tags
    component   = "frontend"
    monitoring  = "datadog"
  }
}

# 🚨 DATADOG NON-COMPLIANT RESOURCE: Missing required Datadog tags
resource "aws_instance" "web_server_non_compliant" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  
  tags = {
    Name = "web-server-dev"
    # Missing: env, service, version, team - will be flagged by IaC scanner
  }
}

# ✅ DATADOG COMPLIANT RESOURCE: S3 bucket with proper Datadog tagging
resource "aws_s3_bucket" "data_bucket_compliant" {
  bucket = "company-data-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name        = "company-data-bucket"
    # Required Datadog tags
    env         = "prod"
    service     = "data-analytics"
    version     = "2.1.0"
    team        = "data-team"
    
    # Data-specific tags
    data_class  = "confidential"
    backup      = "enabled"
    retention   = "7-years"
  }
}

# 🚨 DATADOG NON-COMPLIANT RESOURCE: S3 bucket missing Datadog tags
resource "aws_s3_bucket" "logs_bucket_non_compliant" {
  bucket = "company-logs-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name = "logs-bucket"
    purpose = "logging"
    # Missing ALL required Datadog tags: env, service, version, team
  }
}

# ⚠️ DATADOG PARTIALLY COMPLIANT: Has some Datadog tags but invalid format
resource "aws_rds_instance" "database_partial" {
  identifier     = "company-db"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  storage_type      = "gp2"
  
  db_name  = "company"
  username = var.db_username
  password = var.db_password
  
  tags = {
    Name        = "company-database"
    env         = "dev"  # Valid value
    service     = "Database_Service"  # Invalid: contains uppercase and underscore
    version     = "latest-v1"  # Invalid format
    team        = "Backend Team"  # Invalid: contains space
  }
}

# ✅ DATADOG COMPLIANT RESOURCE: Security group with proper Datadog tags
resource "aws_security_group" "web_sg_compliant" {
  name_prefix = "web-sg-"
  description = "Security group for web servers"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "web-security-group"
    # Required Datadog tags
    env         = "prod"
    service     = "web-security"
    version     = "1.0.0"
    team        = "security-team"
    
    # Security-specific tags
    purpose     = "web-access"
    compliance  = "sox"
  }
}

# 🚨 DATADOG NON-COMPLIANT RESOURCE: Security group with no tags at all
resource "aws_security_group" "database_sg_non_compliant" {
  name_prefix = "db-sg-"
  description = "Security group for database"
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  
  # No tags - completely non-compliant with Datadog requirements
  # Missing: env, service, version, team
}

# ✅ DATADOG COMPLIANT RESOURCE: Lambda function for microservices
resource "aws_lambda_function" "api_handler_compliant" {
  filename         = "api_handler.zip"
  function_name    = "api-handler"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs18.x"
  
  tags = {
    Name        = "api-handler"
    # Perfect Datadog tagging for APM and serverless monitoring
    env         = "prod"
    service     = "user-api"
    version     = "v2.4.1"
    team        = "backend-team"
    
    # Lambda-specific tags
    runtime     = "nodejs18"
    timeout     = "30s"
  }
}

# 🚨 DATADOG NON-COMPLIANT RESOURCE: ECS Service missing version tag
resource "aws_ecs_service" "app_service_partial" {
  name            = "web-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  
  tags = {
    Name    = "web-app-service"
    env     = "staging"
    service = "web-app"
    team    = "platform-team"
    # Missing: version tag - critical for Datadog deployment tracking
  }
}

# Dummy resources for the ECS service
resource "aws_ecs_cluster" "main" {
  name = "main-cluster"
  
  tags = {
    env     = "staging"
    service = "container-orchestration"
    version = "1.0.0"
    team    = "platform-team"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "web-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  
  container_definitions = jsonencode([
    {
      name  = "web-app"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 80
        }
      ]
    }
  ])
  
  tags = {
    env     = "staging"
    service = "web-app"
    version = "1.0.0"
    team    = "platform-team"
  }
}

# IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    env     = "prod"
    service = "iam"
    version = "1.0.0"
    team    = "security-team"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

