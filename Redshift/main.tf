data "aws_vpc" "main" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "tag:Name"
    values = ["private*"]
  }
}

resource "aws_security_group" "redshift_security_group" {
  name        = "redshift-security-group"
  description = "Security group for Redshift cluster"

  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port   = 5439
    to_port     = 5439
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
    Name = "redshift-security-group"
  }
}

resource "aws_redshift_subnet_group" "redshift_sub_group" {
  name       = "redshift-subnet-group"
  subnet_ids = data.aws_subnets.private_subnets.ids

  tags = {
    Name = "redshift-subnet-group"
  }
}

resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier = var.cluster_identifier
  node_type          = var.node_type
  number_of_nodes    = var.number_of_nodes
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  port               = var.port

  vpc_security_group_ids = [aws_security_group.redshift_security_group.id]
  #subnet_group_name      = aws_redshift_subnet_group.redshift_sub_group.name

  tags = {
    Name = "redshift-cluster"
  }
    depends_on = [
    aws_security_group.redshift_security_group,
    aws_redshift_subnet_group.redshift_sub_group
  ]
}
