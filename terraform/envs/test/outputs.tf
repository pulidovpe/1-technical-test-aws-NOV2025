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

# ────────────── EC2 INFO ──────────────
output "ec2" {
  description = "Información completa de las instancias"
  value       = module.ec2.instance_info
}

# ────────────── CONEXIÓN SSH ──────────────
output "ssh_command" {
  description = "Comando SSH listo para copiar-pegar"
  value = length(module.ec2.public_ips) > 0 ? format(
    "ssh -i ~/.ssh/%s.pem %s@%s",
    var.ec2_key_name,
    module.ec2.instance_info.user,
    module.ec2.public_ips[0]
  ) : "No hay IP pública"
}

output "web_url_http" {
  value = length(module.ec2.public_ips) > 0 ? "http://${module.ec2.public_ips[0]}" : "sin IP pública"
}

output "web_url_https" {
  value = length(module.ec2.public_ips) > 0 ? "https://${module.ec2.public_ips[0]}" : "sin IP pública"
}

# ────────────── RESUMEN PRUEBAS ──────────────
output "resumen_pruebas" {
  description = "Resumen Pruebas"
  value = length(module.ec2.public_ips) > 0 ? format(<<-EOT
    ENTORNO DE PRUEBAS LISTO

    VPC:           %s
    Instancia:     %s
    IP pública:    %s
    SO:            %s
    Usuario:       %s

    Conexión SSH:
    ssh -i ~/.ssh/%s.pem %s@%s

    Web:
    HTTP:   http://%s
    HTTPS:  https://%s

    ¡Todo funcionando!

    EOT
    , module.vpc.vpc_id
    , module.ec2.instance_info.instance_ids[0]
    , module.ec2.public_ips[0]
    , upper(replace(var.ec2_os, "ubuntu22", "Ubuntu 22.04 LTS"))
    , module.ec2.instance_info.user
    , var.ec2_key_name
    , module.ec2.instance_info.user
    , module.ec2.public_ips[0]
    , module.ec2.public_ips[0]
    , module.ec2.public_ips[0]
  ) : "No hay instancias con IP pública"
}