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

# Create a public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags,{

    # roboshop-dev-public-us-east-1a

    Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"

  }, var.public_subnet_tags)

}

# Create a private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
 
 # here we are not mapping public IPs to private subnets as these subnets are meant for internal resources that do not require direct internet access. Instead, these resources can access the internet through a NAT gateway or other means if necessary, while still being protected from direct exposure to the internet.

  tags = merge(local.common_tags,{

    # roboshop-dev-private-us-east-1a

    Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"

  }, var.private_subnet_tags)


    
  }

# Create a database subnet

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
 
 # here we are not mapping public IPs to database subnets as these subnets are meant for internal resources that do not require direct internet access. Instead, these resources can access the internet through a NAT gateway or other means if necessary, while still being protected from direct exposure to the internet.

  tags = merge(local.common_tags,{

    # roboshop-dev-database-us-east-1a

    Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"

  }, var.database_subnet_tags)

   
  }  

  # Create a public route table for the VPC

  resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  

  tags = merge(local.common_tags,{

    # roboshop-dev-public-us-east-1a

    Name = "${var.project}-${var.environment}-public"

  }, var.public_route_table_tags)
}

# Create a private route table for the VPC
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  

  tags = merge(local.common_tags,{

    # roboshop-dev-private-us-east-1a

    Name = "${var.project}-${var.environment}-private"

  }, var.private_route_table_tags)
}

# Create a database route table for the VPC
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  

  tags = merge(local.common_tags,{

    # roboshop-dev-database-us-east-1a

    Name = "${var.project}-${var.environment}-database"

  }, var.database_route_table_tags)
}
