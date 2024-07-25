provider "aws" {
  region = var.REGION
}

#This custom module will create resources such as VPC, Subnets, Routes, Subnet association, IGW, NAT, EIP, VPC Endpoint.
#---------- VPC -------------

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.CIDR
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = var.ENVIRONMENT_NAME
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

#---------- Internet Gateway and NAT Gateway -------------

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-igw"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

# Fetch Elastic IP for NAT gateway
data "aws_eip" "final-prod-us-east-1a" {
  id = "eipalloc-009d55a176ca05203"
  # tags = {
  #   Name = "${var.ENVIRONMENT_NAME}-${var.REGION}a"
  # }
}

data "aws_eip" "final-prod-us-east-1b" {
  id = "eipalloc-03577da23301c234e"
  # tags = {
  #   Name = "${var.ENVIRONMENT_NAME}-${var.REGION}b"
  # }
}

# data "aws_eip" "nat_eip_1c" {
#   tags = {
#     Name = "${var.ENVIRONMENT_NAME}-${var.REGION}c"
#   }
# }

# Create NAT gateway
resource "aws_nat_gateway" "nat-1a" {
  allocation_id = data.aws_eip.final-prod-us-east-1a.id
  subnet_id     = aws_subnet.web-public[0].id

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-nat-1a"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

resource "aws_nat_gateway" "nat-1b" {
  allocation_id = data.aws_eip.final-prod-us-east-1b.id
  subnet_id     = aws_subnet.web-public[1].id

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-nat-1b"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

#---------- Admin Subnet -------------

#Create private subnet for admin
resource "aws_subnet" "admin-private" {
  count             = 1
  cidr_block        = cidrsubnet(var.CIDR, 6, count.index + 0)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.REGION}${element(["a"], count.index)}"

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-admin-private-1${element(["a"], count.index)}"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

#Create public subnet for admin
resource "aws_subnet" "admin-public" {
  count             = 1
  cidr_block        = cidrsubnet(var.CIDR, 6, count.index + 1)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.REGION}${element(["a"], count.index)}"

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-admin-public-1${element(["a"], count.index)}"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

#---------- VPN Subnet -------------

resource "aws_subnet" "vpn-public" {
  count             = 2
  cidr_block        = cidrsubnet(var.CIDR, 6, count.index + 2)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.REGION}${element(["a", "b"], count.index)}"

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-vpn-public-1${element(["a", "b"], count.index)}"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

#---------- Web(IIS) Subnet -------------

resource "aws_subnet" "web-private" {
  count             = 2
  cidr_block        = cidrsubnet(var.CIDR, 6, count.index + 4)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.REGION}${element(["a", "b"], count.index)}"

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-web-private-1${element(["a", "b"], count.index)}"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

resource "aws_subnet" "web-public" {
  count             = 2
  cidr_block        = cidrsubnet(var.CIDR, 6, count.index + 7)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.REGION}${element(["a", "b"], count.index)}"

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-web-public-1${element(["a", "b"], count.index)}"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

#---------- SQL Subnet -------------

resource "aws_subnet" "sql-private" {
  count             = 2
  cidr_block        = cidrsubnet(var.CIDR, 6, count.index + 10)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.REGION}${element(["a", "b"], count.index)}"

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-sql-private-1${element(["a", "b"], count.index)}"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

resource "aws_subnet" "sql-public" {
  count             = 2
  cidr_block        = cidrsubnet(var.CIDR, 6, count.index + 13)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.REGION}${element(["a", "b"], count.index)}"

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-sql-public-1${element(["a", "b"], count.index)}"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

#---------- VPC Endpoint -------------

resource "aws_vpc_endpoint" "s3-endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.REGION}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.private-route-1a.id, aws_route_table.private-route-1b.id, aws_route_table.public-route.id]

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-s3-endpoint"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

# # Security Group for Athena Interface Endpoint
# resource "aws_security_group" "athena-endpoint-sg" {
#   name        = "${var.ENVIRONMENT_NAME}-athena-endpoint-sg"
#   description = "Security Group For Athena Endpoint"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     description     = "HTTPS"
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     cidr_blocks     = ["${var.CIDR}"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "${var.ENVIRONMENT_NAME}-athena-endpoint-sg"
#     Environment = var.TAGS[0].Environment
#     Tier = var.TAGS[0].Tier
#     Role = var.TAGS[0].Role
#   }
# }

# # Create AWS Athena Interface Endpoint
# resource "aws_vpc_endpoint" "athena-endpoint" {
#   vpc_id              = aws_vpc.vpc.id
#   service_name        = "com.amazonaws.${var.REGION}.athena"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.athena-endpoint-sg.id]
#   subnet_ids          = [aws_subnet.web-private[0].id, aws_subnet.web-private[1].id]
#   private_dns_enabled = true
#   tags = {
#     Name = "${var.ENVIRONMENT_NAME}-athena-endpoint"
#     Environment = var.TAGS[0].Environment
#     Tier = var.TAGS[0].Tier
#     Role = var.TAGS[0].Role
#   }
# }

# data "aws_ec2_managed_prefix_list" "cloudfront_prefix_list" {
#   name = "com.amazonaws.global.cloudfront.origin-facing"
# }

#---------- Route tables -------------

resource "aws_route_table" "private-route-1a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1a.id
  }

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-private-1a-route"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

resource "aws_route_table" "private-route-1b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1b.id
  }

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-private-1b-route"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-public-route"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

#---------- Admin Subnet Association -------------

resource "aws_route_table_association" "private-admin-subnet-association" {
  count = 1

  subnet_id      = element("${aws_subnet.admin-private.*.id}", count.index)
  route_table_id = aws_route_table.private-route-1a.id
}

resource "aws_route_table_association" "public-admin-subnet-association" {
  count = 1

  subnet_id      = element("${aws_subnet.admin-public.*.id}", count.index)
  route_table_id = aws_route_table.public-route.id
}

#---------- VPN Subnet Association -------------

resource "aws_route_table_association" "public-vpn-subnet-association" {
  count = 2

  subnet_id      = element("${aws_subnet.vpn-public.*.id}", count.index)
  route_table_id = aws_route_table.public-route.id
}

#---------- Web Subnet Association -------------

resource "aws_route_table_association" "private-web-subnet-association-1a" {
  subnet_id      = aws_subnet.web-private[0].id
  route_table_id = aws_route_table.private-route-1a.id
}

resource "aws_route_table_association" "private-web-subnet-association-1b" {
  subnet_id      = aws_subnet.web-private[1].id
  route_table_id = aws_route_table.private-route-1b.id
}

resource "aws_route_table_association" "public-web-subnet-association" {
  count = 2

  subnet_id      = element("${aws_subnet.web-public.*.id}", count.index)
  route_table_id = aws_route_table.public-route.id
}

#---------- SQL Subnet Association -------------

resource "aws_route_table_association" "private-sql-subnet-association-1a" {
  subnet_id      = aws_subnet.sql-private[0].id
  route_table_id = aws_route_table.private-route-1a.id
}

resource "aws_route_table_association" "private-sql-subnet-association-1b" {
  subnet_id      = aws_subnet.sql-private[1].id
  route_table_id = aws_route_table.private-route-1b.id
}

resource "aws_route_table_association" "public-sql-subnet-association" {
  count = 2

  subnet_id      = element("${aws_subnet.sql-public.*.id}", count.index)
  route_table_id = aws_route_table.public-route.id
}
