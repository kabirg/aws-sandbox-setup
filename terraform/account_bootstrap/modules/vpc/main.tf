####################################
######### VPC COMPONENTS ###########
####################################

# PROVIDER
provider "aws" {
  region  = "us-east-1"
}

variable "component_name" {
  type = string
  description = "Name-prefix for all account resources."
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR"
}

variable "subnet_cidrs" {
  type = map(string)
  description = "Map of subnet CIDR's w/two key/value pairs (for public/private subnets)."
}

#VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.component_name}-vpc"
  }
}

#SUBNETS
resource "aws_subnet" "public-subnet" {
  cidr_block              = var.subnet_cidrs.public
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id
  tags = {
    Name = "${var.component_name}-public-subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  cidr_block = var.subnet_cidrs.private
  vpc_id     = aws_vpc.vpc.id
  tags = {
    Name = "${var.component_name}-private-subnet"
  }
}

#IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.component_name}-igw"
  }
}

#ROUTE TABLE FOR PUBLIC SUBNET
resource "aws_route_table" "kabir-public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.component_name}-public-rt"
  }
}

resource "aws_route_table_association" "public-rt-ass" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.kabir-public-rt.id
}

# OUTPUTS
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public-subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private-subnet.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "public_rt_id" {
  value = aws_route_table.kabir-public-rt.id
}
