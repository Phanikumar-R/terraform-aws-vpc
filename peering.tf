resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0   # Conditionally create the peering connection based on the variable here 1 means create 0 means do not create
 /*  peer_owner_id = var.peer_owner_id */ # Optional: Specify the AWS account ID of the owner of the peer VPC if it's in a different account
  
  #Acceptor
  peer_vpc_id   = data.aws_vpc.default.id # The ID of the peer VPC to connect to. This should be the VPC you want to peer with.
  
  #Requester
  vpc_id        = aws_vpc.main.id # The ID of your VPC that you want to peer from. This should be the VPC you are creating in this module.  

  auto_accept = true # Automatically accept the peering connection. Set to false if you want to manually accept it in the AWS console or via CLI.    
  
  
  
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(local.common_tags,

    {
      Name = "${var.project}-${var.environment}-default-peering"
    }
  )
}