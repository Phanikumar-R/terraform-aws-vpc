variable "project" {

    description = "roboshop for which the VPC is being created."
    type        = string
    default     = "roboshop"
  
}

variable "environment" {
    description = "environment for which the VPC is being created."
    type        = string
    default     = "dev"
  
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
    description = "Additional tags to apply to the VPC."
    type        = map(string)
    default     = {}
  
}
variable "igw_tags" {
    type = map(string)
    default = {}
  
}

variable "public_subnet_cidrs" {
    description = "List of CIDR blocks for public subnets."
    type        = list(string)
    default     = ["10.0.1.0/24","10.0.2.0/24"]
  
}

variable "public_subnet_tags" {
    description = "Additional tags to apply to the public subnets."
    type        = map(string)
    default     = {}
  
}

variable "private_subnet_cidrs" {
    description = "List of CIDR blocks for private subnets."
    type        = list(string)
    default     = ["10.0.11.0/24","10.0.12.0/24"]
  
}

variable "private_subnet_tags" {
    description = "Additional tags to apply to the private subnets."
    type        = map(string)
    default     = {}
  
}

variable "database_subnet_cidrs" {
    description = "List of CIDR blocks for database subnets."
    type        = list(string)
    default     = ["10.0.21.0/24","10.0.22.0/24"]
  
}

variable "database_subnet_tags" {
    description = "Additional tags to apply to the database subnets."
    type        = map(string)
    default     = {}
  
}

variable "public_route_table_tags" {
    description = "Additional tags to apply to the public route table."
    type        = map(string)
    default     = {}
  
}

variable "private_route_table_tags" {
    description = "Additional tags to apply to the private route table."
    type        = map(string)
    default     = {}
  
}

variable "database_route_table_tags" {
    description = "Additional tags to apply to the database route table."
    type        = map(string)
    default     = {}
  
}