resource "aws_vpc" "main" {                  # Step-1: Create a VPC
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  
  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {     # Step-2: Create an Internet Gateway
  vpc_id = aws_vpc.main.id # VPC Association

  tags = local.igw_final_tags
}

# Create a public subnet
resource "aws_subnet" "public" {             # Step-3: Create a public subnet
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

# Create a private subnet                 #Step-4: Create a private subnet
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

resource "aws_subnet" "database" {        #Step-5: Create a database subnet
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

  resource "aws_route_table" "public" {       #Step-6: Create a public route table for the VPC
  vpc_id = aws_vpc.main.id

  

  tags = merge(local.common_tags,{

    # roboshop-dev-public-us-east-1a

    Name = "${var.project}-${var.environment}-public"

  }, var.public_route_table_tags)
}

# Create a private route table for the VPC        #Step-7: Create a private route table for the VPC
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  

  tags = merge(local.common_tags,{

    # roboshop-dev-private-us-east-1a

    Name = "${var.project}-${var.environment}-private"

  }, var.private_route_table_tags)
}

# Create a database route table for the VPC  #Step-8: Create a database route table for the VPC
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  

  tags = merge(local.common_tags,{

    # roboshop-dev-database-us-east-1a

    Name = "${var.project}-${var.environment}-database"

  }, var.database_route_table_tags)
}

# Associate the public subnet with the public route table

resource "aws_route" "public"{                  #Step-9: Associate the public subnet with the public route table
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}


resource "aws_eip" "nat" {
  domain  = "vpc"

  tags = merge(local.common_tags,{

   

    Name = "${var.project}-${var.environment}-nat"

  }, var.eip_tags)
  
 }

# Create a NAT Gateway in the public subnet

 resource "aws_nat_gateway" "main" {        #Step-10: Create a NAT Gateway in the public subnet
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # We are creating the NAT Gateway in the first public subnet i.e US East-1a Availability Zone a

  tags = merge(local.common_tags,{

    Name = "${var.project}-${var.environment}-nat"

  }, var.nat_gateway_tags)

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

# Create a route in the private route table to direct internet-bound traffic through the NAT Gateway

resource "aws_route" "private"{
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}


# Create a route in the database route table to direct internet-bound traffic through the NAT Gateway
resource "aws_route" "database"{
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

