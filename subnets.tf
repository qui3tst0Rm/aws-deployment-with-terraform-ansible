#Create subnet no:1 in eu-west-1
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc-master.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "subnet-1(vpc-master)"
  }
}

#Create subnet no:2 in eu-west-1
resource "aws_subnet" "subnet_2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc-master.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "subnet-2(vpc-master)"
  }
}

#Create subnet no1 in eu-west-2
resource "aws_subnet" "subnet_1_London" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc-master-London.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "subnet-1(vpc-worker)"
  }
}