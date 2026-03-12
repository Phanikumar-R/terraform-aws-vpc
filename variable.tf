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