data "aws_vpc" "main" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["*web-private*"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

resource "aws_db_subnet_group" "db_subnet_group_name" {
  name = "${var.ENVIRONMENT_NAME}-db-subnet-group"
  subnet_ids = data.aws_subnets.private.ids
}

resource "aws_security_group" "db_sg" {
  name        = "${var.ENVIRONMENT_NAME}-db-SG"
  description = "Security group for RDS database"

  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [var.CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "default" {
  identifier              = var.IDENTIFIER
  engine                  = var.ENGINE
  engine_version          = var.ENGINE_VERSION
  instance_class          = var.DB_INSTANCE_TYPE
  allocated_storage       = var.MIN_ALLOCATED_STORAGE
  max_allocated_storage   = var.MAX_ALLOCATED_STORAGE
  storage_type            = var.STORAGE_TYPE
  #storage_encrypted       = true
  #kms_key_id              = data.aws_kms_key.rds_key.arn
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group_name.name
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  deletion_protection     = false
  backup_retention_period = 7
  #license_model           = "license-included"
  skip_final_snapshot     = true
  username                = var.DB_USERNAME
  password                = var.Password
  backup_window           = "02:00-03:00"

  multi_az                = false

  tags = {
    Name = var.IDENTIFIER
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }

  timeouts {
    create = "60m"
    delete = "60m"
  }
}

output "db_endpoint" {
  value = aws_db_instance.default.endpoint
}
