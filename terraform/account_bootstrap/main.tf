####################################
#### SANDBOX ACCOUNT BOOTSTRAP #####
####################################

# PROVIDER
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

module "vpc" {
  component_name = var.component_name
  vpc_cidr = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
  source = "./modules/vpc"
}

module "security" {
  component_name = var.component_name
  vpc_id = module.vpc.vpc_id
  source = "./modules/security"
}

module "sandbox_ec2_instance" {
  enabled = var.provision_sandbox_instance
  component_name = var.component_name
  subnet_id = module.vpc.public_subnet_id
  vpc_sg_id = module.security.public_sg_id
  instance_ami = var.instance_ami
  instance_type = var.instance_type
  instance_key_pair = var.instance_key_pair
  source = "./modules/ec2"
}
