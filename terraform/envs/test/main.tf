# ==================== envs/test/main.tf ====================

module "vpc" {
  source = "../../modules/vpc"

  Project                   = var.Project
  vpc_name                  = var.vpc_name
  Environment               = var.Environment
  vpc_cidr                  = var.vpc_cidr
  availability_zones_to_use = var.availability_zones_to_use

  create_private_subnets     = var.create_private_subnets
  nat_gateway_configuration  = var.nat_gateway_configuration

  force_public_subnet_name  = var.force_public_subnet_name

  enable_https_from_world    = var.enable_https_from_world
  enable_ssh_from_world      = var.enable_ssh_from_world

  ipv6_support = false
}

module "ec2" {
  source = "../../modules/ec2"

  Project             = var.Project
  Environment         = var.Environment
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets

  name_prefix         = var.ec2_name_prefix
  instance_type       = var.ec2_instance_type
  os                  = var.ec2_os
  instance_count      = var.ec2_instance_count
  existing_key_name   = var.ec2_key_name
  enable_public_ip    = true

  # SG DEL MÓDULO NETWORK (con 22, 443 abiertos)
  security_group_ids  = [module.vpc.public_security_group_id]

  user_data_file    = "../../scripts/install-nginx-https.sh"
}
