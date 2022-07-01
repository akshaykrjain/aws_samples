# A Basic VPC with 3 Sets of Public and Private Subnets

locals {
  vpc_name = "dev"
  vpc_cidr = "10.0.0.0/16"
}

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr
  tags = {
    "Name" = local.vpc_name
  }
}

locals {
  cidrs = cidrsubnets(aws_vpc.main.cidr_block, 8, 8, 8, 12, 12, 12) #Modify size according to your needs
}

locals {
  private_subnet_cidrs = slice(local.cidrs, 0, 3)
}


resource "aws_subnet" "private" {
  for_each                = toset(local.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.key
  map_public_ip_on_launch = false
  tags = {
    Name = "${local.vpc_name}-private-${sum([index(local.private_subnet_cidrs, each.key), 1])}"
  }
}

locals {
  public_subnet_cidrs = slice(local.cidrs, 3, 6)
}


resource "aws_subnet" "public" {
  for_each                = toset(local.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.vpc_name}-public-${sum([index(local.public_subnet_cidrs, each.key), 1])}"
  }
}
