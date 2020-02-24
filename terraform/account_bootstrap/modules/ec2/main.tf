####################################
##### EC2 INSTANCE COMPONENTS ######
####################################

# PROVIDER
provider "aws" {
  region  = "us-east-1"
}

variable "enabled" {
  type = bool
  description = "Provision or not."
}

variable "component_name" {
  type = string
  description = "Name-prefix for all account resources."
}

variable "subnet_id" {
  type = string
  description = "Subnet ID."
}

variable "vpc_sg_id" {
  type = string
  description = "VPC SG ID."
}

variable "instance_ami" {
  type = string
  description = "AMI for EC2 instance"
}

variable "instance_type" {
  type = string
  description = "Instance type"
}

variable "instance_key_pair" {
  type = string
  description = "Instance key pair name"
}

# TEST INSTANCE
resource "aws_instance" "sandbox-instance" {
  count = var.enabled ? 1 : 0
  ami                         = var.instance_ami
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.instance_key_pair
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.vpc_sg_id]
  tags = {
    Name = "${var.component_name}-instance"
  }
}

# OUTPUTS
output "ec2_instance_id" {
  value = aws_instance.sandbox-instance[0].id
}
