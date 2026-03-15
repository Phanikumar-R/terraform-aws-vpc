output "azs_info" {
    value = data.aws_availability_zones.available
  
}

output "vpc_id" {
    value = aws_vpc.main.id
}


output "public_subnet_ids" {

    value = aws_subnet.public[*].id     # Step-5: Output the public subnet IDs
  
}

output "private_subnet_ids" {

    value = aws_subnet.private[*].id     # Step-5: Output the private subnet IDs
  
}

output "database_subnet_ids" {

    value = aws_subnet.database[*].id     # Step-5: Output the database subnet IDs
  
}