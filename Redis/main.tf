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


resource "aws_security_group" "redis_sg" {
  name        = "redis-security-group"
  vpc_id      = data.aws_vpc.main.id  

  ingress {
    from_port   = var.port  
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "redis_sub_group" {
  name       = "RedisSubnetGroup"
  subnet_ids = tolist(data.aws_subnets.private.ids)
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = var.port
  subnet_group_name    = aws_elasticache_subnet_group.redis_sub_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}
