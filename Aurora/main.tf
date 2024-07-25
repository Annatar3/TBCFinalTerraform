# Fetch the VPC by name
data "aws_vpc" "main" {
  tags = {
    Name = var.vpc_name
  }
}

# Fetch private subnets by tag
data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Name"
    values = ["private*"]
  }
  #vpc_id = data.aws_vpc.main.id
}

# Create a security group for Aurora
resource "aws_security_group" "aurora_sg" {
  name        = "${var.cluster_identifier}-sg"
  description = "Aurora security group"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id] # Allow traffic from ECS tasks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_identifier}-sg"
  }
}

# Create an Aurora PostgreSQL cluster
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-postgresql"
  engine_version          = var.engine_version
  master_username         = var.master_username
  master_password         = var.master_password
  database_name           = var.database_name
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  db_subnet_group_name    = var.db_subnet_group_name # Reference existing subnet group

  tags = {
    Name = var.cluster_identifier
  }
}

# Create the master instance
resource "aws_rds_cluster_instance" "aurora_master" {
  identifier              = "${var.cluster_identifier}-master"
  cluster_identifier      = aws_rds_cluster.aurora_cluster.id
  instance_class          = var.instance_class
  engine                  = aws_rds_cluster.aurora_cluster.engine
  engine_version          = aws_rds_cluster.aurora_cluster.engine_version
  db_subnet_group_name    = var.db_subnet_group_name # Reference existing subnet group
  publicly_accessible     = false

  tags = {
    Name = "${var.cluster_identifier}-master"
  }
}

# Create read replicas
resource "aws_rds_cluster_instance" "aurora_read_replica" {
  count                   = var.replica_count
  identifier              = "${var.cluster_identifier}-replica-${count.index}"
  cluster_identifier      = aws_rds_cluster.aurora_cluster.id
  instance_class          = var.instance_class
  engine                  = aws_rds_cluster.aurora_cluster.engine
  engine_version          = aws_rds_cluster.aurora_cluster.engine_version
  db_subnet_group_name    = var.db_subnet_group_name # Reference existing subnet group
  publicly_accessible     = false

  tags = {
    Name = "${var.cluster_identifier}-replica-${count.index}"
  }
}
