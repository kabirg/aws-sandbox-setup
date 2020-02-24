#############
## OUTPUTS ##
#############

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "public_rt_id" {
  value = module.vpc.public_rt_id
}

output "public_sg_id" {
  value = module.security.public_sg_id
}

output "ec2_instance_id" {
  value = module.sandbox_ec2_instance.ec2_instance_id
}
