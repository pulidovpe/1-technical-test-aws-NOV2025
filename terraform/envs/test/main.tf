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
