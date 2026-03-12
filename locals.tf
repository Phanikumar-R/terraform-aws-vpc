locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    Terraform  = "true"
  }

  vpc_final_tags = merge (local.common_tags ,
                      {

                        Name = "${var.project}-${var.environment}-vpc"
                      }, var.vpc_tags)

  igw_final_tags = merge (local.common_tags ,
                      {

                        Name = "${var.project}-${var.environment}-ig"
                      }, var.igw_tags)

  az_names = slice(data.aws_availability_zones.available.names, 0, 2) # here 0 is inclusive and 2 is exclusive so it will give us 2 azs

}