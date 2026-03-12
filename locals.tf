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

}