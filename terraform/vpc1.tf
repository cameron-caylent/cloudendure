# eip

resource "aws_eip" "eip-01" {
  vpc = true
  tags = {
    Client = "wine.com"
  }

}



# internet gateway

resource "aws_internet_gateway" "gateway-01" {
  vpc_id = aws_vpc.vpc-01.id

  tags = {
    Client = "wine.com"
  }

}



# route table

resource "aws_route_table" "route-table-01" {
  vpc_id = aws_vpc.vpc-01.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway-01.id
  }

  tags = {
    Client = "wine.com"
  }

}



# route table association

resource "aws_route_table_association" "route-association-01" {
  subnet_id      = aws_subnet.public-subnet-01.id
  route_table_id = aws_route_table.route-table-01.id

}



# vpc

resource "aws_vpc" "vpc-01" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Client = "wine.com"
  }
}



# create public subnet

resource "aws_subnet" "public-subnet-01" {
  cidr_block        = cidrsubnet(aws_vpc.vpc-01.cidr_block, 3, 1)
  vpc_id            = aws_vpc.vpc-01.id
  availability_zone = "us-west-2a"
  tags = {
    Client = "wine.com"
  }
}



# create security group

resource "aws_security_group" "ingress-sg-01" {
  name   = "allow-ssh-sg"
  vpc_id = aws_vpc.vpc-01.id

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

  tags = {
    Client = "wine.com"
  }
}

