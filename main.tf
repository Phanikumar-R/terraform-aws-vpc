locals {
  vpc_final_tags = {
    Name = "main-vpc"
  }
  igw_final_tags = {
    Name = "main-igw"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  
  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # VPC Association

  tags = local.igw_final_tags
}