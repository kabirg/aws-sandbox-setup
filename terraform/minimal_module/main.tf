####################################
#### SANDBOX ACCOUNT BOOTSTRAP #####
####################################

##############
## PROVIDER ##
##############
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

###############
## VARIABLES ##
###############
variable "component_name" {
  type = string
  description = "Name-prefix for all account resources."
  default = "kabirg-terrafrom"
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR"
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type = map(string)
  description = "Map of subnet CIDR's w/two key/value pairs (for public/private subnets)."
  default = {
    public = "10.0.1.0/24",
    private = "10.0.10.0/24"
  }
}

variable "instance_ami" {
  type = string
  description = "AMI for EC2 instance"
  default = "ami-0a887e401f7654935"
}

variable "instance_type" {
  type = string
  description = "Instance type"
  default = "t2.micro"
}

variable "instance_key_pair" {
  type = string
  description = "Instance key pair name"
  default = "kabirg"
}

###############
## RESOURCES ##
###############

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

# SG
resource "aws_security_group" "public-sg" {
  name        = "${var.component_name}-public-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

# TEST INSTANCE
resource "aws_instance" "kabir-test-tf-instance" {
  ami                         = var.instance_ami
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.instance_key_pair
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.public-sg.id]
  tags = {
    Name = "${var.component_name}-instance"
  }
}

#############
## OUTPUTS ##
#############
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

output "public_sg_id" {
  value = aws_security_group.public-sg.id
}

output "public_rt_id" {
  value = aws_route_table.kabir-public-rt.id
}

output "ec2_instance_id" {
  value = aws_instance.kabir-test-tf-instance.id
}
