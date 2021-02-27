
#Create IGW in eu west 1
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc-master.id
}

#Create IGW in eu west 2
resource "aws_internet_gateway" "igw-London" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc-master-London.id
}

#Get all availability AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}


###Create route table in eu-west-1###
resource "aws_route_table" "internet_route" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc-master.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block                = "192.168.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.euwest1-euwest2.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Master-Region-RT"
  }

}

###Overwrite default route table of VPC(Master) with our route table entries###
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.region-master
  vpc_id         = aws_vpc.vpc-master.id
  route_table_id = aws_route_table.internet_route.id
}


#Create route table in eu-west-2
resource "aws_route_table" "internet_route_London" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc-master-London.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-London.id
  }
  route {
    cidr_block                = "10.0.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.euwest1-euwest2.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Worker-Region-RT"
  }

}

###Overwrite default route table of VPC(Master) with our route table entries###
resource "aws_main_route_table_association" "set-worker-default-rt-assoc" {
  provider       = aws.region-worker
  vpc_id         = aws_vpc.vpc-master-London.id
  route_table_id = aws_route_table.internet_route_London.id
}
