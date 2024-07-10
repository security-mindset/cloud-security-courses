provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-vpc"
  })
}

resource "aws_subnet" "public" {
  count                  = length(var.public_subnet_cidr_blocks)
  cidr_block             = var.public_subnet_cidr_blocks[count.index]
  vpc_id                 = aws_vpc.main.id
  availability_zone      = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-public-${count.index + 1}"
  })
}

resource "aws_internet_gateway" "sm_igw" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "sm-igw"
  }
}

resource "aws_route_table" "sm_route_table" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sm_igw.id
  }
  
  tags = {
    Name = "sm-route-table"
  }
}

resource "aws_route_table_association" "example_subnet_association" {
  count             = length(aws_subnet.public)
  subnet_id         = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.sm_route_table.id
}

