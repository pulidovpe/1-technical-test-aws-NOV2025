# ==================== envs/test/outputs.tf ====================

# ────────────── VPC INFO ──────────────
output "vpc_info" {
  description = "Información de la VPC"
  value = {
    vpc_id                   = module.vpc.vpc_id
    vpc_cidr                 = module.vpc.vpc_cidr
    public_subnets           = module.vpc.public_subnets
    private_subnets          = module.vpc.private_subnets
    public_security_group_id = module.vpc.public_security_group_id
  }
}
