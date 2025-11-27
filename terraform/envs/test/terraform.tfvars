# ==================== envs/test/terraform.tfvars ====================

Project                     = "prueba-tecnica"
Environment                 = "test"
Region                      = "us-east-1"

# ──────────────── VPC de prueba) ────────────────
vpc_name                    = "web-app-vpc"
vpc_cidr                    = "10.99.0.0/16"

availability_zones_to_use   = 1                     # solo 1 AZ
ipv6_support                = false

# Sin subnets privadas → sin NAT
create_private_subnets      = false
create_public_subnets       = true
nat_gateway_configuration   = "none"

# Seguridad para pruebas rápidas
enable_https_from_world     = true                  # habilitar puerto 443
enable_ssh_from_world       = true                  # solo en test, nunca en prod
allowed_ingress_cidr        = null                  # permite el "from world" de arriba

force_public_subnet_name = "web-app-subnet"

# ──────── EC2 (1 instancia de prueba) ────────
ec2_name_prefix           = "ubuntu"
ec2_instance_count        = 1
ec2_instance_type         = "t3.micro"
ec2_os                    = "ubuntu22"

ec2_key_name              = "devops-tmp"

# IP pública + SG del VPC (Se reutiliza el público que ya abre 22 y 443)
ec2_enable_public_ip      = true