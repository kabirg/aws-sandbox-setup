###############
## VARIABLES ##
###############

variable "component_name" {
  type = string
  description = "Name-prefix for all account resources."
  default = "kabirg-terraform"
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

variable "provision_sandbox_instance" {
  type = bool
  description = "Decide whether or not to create an sandbox instance to play with."
  default = true
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
