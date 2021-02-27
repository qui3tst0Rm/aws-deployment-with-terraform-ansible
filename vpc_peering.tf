#Initiate Peering connection request from eu-wet-1 vpc
resource "aws_vpc_peering_connection" "euwest1-euwest2" {
  provider    = aws.region-master
  peer_vpc_id = aws_vpc.vpc-master-London.id
  vpc_id      = aws_vpc.vpc-master.id
  peer_region = var.region-worker
}

#Accept VPC Peering request in eu-west-2 vpc
resource "aws_vpc_peering_connection_accepter" "accept_peering" {
  provider                  = aws.region-worker
  vpc_peering_connection_id = aws_vpc_peering_connection.euwest1-euwest2.id
  auto_accept               = true
}