####################################
##### FIREWALL (SG) COMPONENTS #####
####################################

# PROVIDER
provider "aws" {
  region  = "us-east-1"
}

variable "component_name" {
  type = string
  description = "Name-prefix for all account resources."
}

variable "vpc_id" {
  type = string
  description = "ID of the VPC within which this SG will reside"
}

# SG
resource "aws_security_group" "public-sg" {
  name        = "${var.component_name}-public-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

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

# OUTPUTS
output "public_sg_id" {
  value = aws_security_group.public-sg.id
}
