# eip

resource "aws_eip" "eip" {
  vpc = true
}



# internet gateway

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}



# route table

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}



# route table association

resource "aws_route_table_association" "route-association" {
  subnet_id      = aws_subnet.public-subnet-00.id
  route_table_id = aws_route_table.route-table.id
}



# vpc

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}



# create public subnet

resource "aws_subnet" "public-subnet-00" {
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 3, 1)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-west-2a"
}



# create security group

resource "aws_security_group" "ingress-sg" {
  name   = "allow-all-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

