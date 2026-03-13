# Terraform AWS VPC

This module creates following resources

1. VPC - CIDR
2.IGW with VPC Association
3.subnets -> public private database
4.route table -> public private database
5.Associations and Routes
6.EIP
7.NAT Gateway -> To provide egress internet access to resources in private subnets
8.VPC peering with default vpc on condition
9.Route table entries through peering


# Inputs

Project -(Required) -string type-User should pass the project name
Environment-(Required)-String type -User should mention the environment type to create resources


# Outputs

