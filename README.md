# 1-technical-test-aws-NOV2025

**Resumen:**
Proyecto Terraform para desplegar una VPC de prueba y una o varias instancias EC2 en AWS. El entorno incluido en este repo es `envs/test` y utiliza los módulos `vpc` y `ec2` localizados en `terraform/modules`.

**Tecnologías usadas:**
- `Terraform` (infraestructura como código).
- `AWS` (VPC, Subnets, Internet Gateway, EIP, NAT Gateway, Security Groups, EC2).
- `bash` (scripts de instalación en `terraform/scripts`).

**Estructura relevante:**
- `terraform/envs/test/` — configuración del entorno `test` (variables, `main.tf`, `providers.tf`, `terraform.tfvars`).
- `terraform/modules/vpc/` — módulo que crea VPC, subnets públicas/privadas, IGW, NAT, route tables, security groups.
- `terraform/modules/ec2/` — módulo que crea instancias EC2 (usa AMIs dinámicas por `os`, soporta `user_data`).
- `terraform/backend/` — configuraciones de backend (si aplicable).
- `terraform/scripts/install-nginx-https.sh` — script de user-data usado para instalar nginx y configurar HTTPS en la instancia de ejemplo.

**Cómo usar (env `test`)**

1. Sitúate en el entorno `test`:

```
cd terraform/envs/test
```

2. Configura credenciales de AWS (por ejemplo):

```bash
export AWS_ACCESS_KEY_ID=YOUR_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET
export AWS_DEFAULT_REGION=us-east-1
```

o usando `aws configure`.

3. Revisa (y opcionalmente modifica) `terraform.tfvars` en este directorio. Ejemplo incluido ya con valores para test.

4. Inicializa Terraform (si usas backend aparte, pásale el `backend` correspondiente):

```bash
terraform init -reconfigure -backend-config=../../backend/test.hcl
```

5. Plan y apply:

```bash
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

6. Para destruir los recursos:

```bash
terraform destroy -var-file="terraform.tfvars"
```

**Variables del entorno `test` (resumen)**

Estas variables están definidas en `terraform/envs/test/variables.tf` y se han provisto en `terraform/envs/test/terraform.tfvars`:

- `Project` (string) — nombre del proyecto.
- `Region` (string) — región AWS (ej: `us-east-1`).
- `Environment` (string) — entorno (ej: `test`).

VPC / networking:
- `vpc_name` (string)
- `vpc_cidr` (string)
- `availability_zones_to_use` (number)
- `create_public_subnets` (bool)
- `create_private_subnets` (bool)
- `nat_gateway_configuration` (string) — `none|single|one_per_az`
- `enable_https_from_world` (bool)
- `enable_ssh_from_world` (bool) — en `test` está activado, no recomendado en `prod`.
- `ipv6_support` (bool)
- `force_public_subnet_name` (string|null)
- `allowed_ingress_cidr` (string|null)

EC2:
- `ec2_name_prefix` (string)
- `ec2_instance_count` (number)
- `ec2_instance_type` (string)
- `ec2_os` (string) — soporta `amazon2`, `ubuntu22`, `ubuntu24`, `rhel9`, `windows2022`.
- `ec2_key_name` (string)
- `ec2_enable_public_ip` (bool)

Además, el módulo `ec2` espera como inputs algunos outputs del módulo `vpc`:
- `vpc_id` (string) — `module.vpc.vpc_id`
- `subnet_ids` (list(string)) — `module.vpc.public_subnets` (u otras subnets)
- `security_group_ids` (list(string)) — por ejemplo `module.vpc.public_security_group_id`

**Contenido del `terraform.tfvars` (ejemplo usado en `test`)**

El archivo `terraform/envs/test/terraform.tfvars` incluido en el repo contiene el siguiente ejemplo (ya preconfigurado para pruebas):

```hcl
Project                     = "prueba-tecnica"
Environment                 = "test"
Region                      = "us-east-1"

# VPC
vpc_name                    = "web-app-vpc"
vpc_cidr                    = "10.99.0.0/16"
availability_zones_to_use   = 1
ipv6_support                = false
create_private_subnets      = false
create_public_subnets       = true
nat_gateway_configuration   = "none"
enable_https_from_world     = true
enable_ssh_from_world       = true
allowed_ingress_cidr        = null
force_public_subnet_name    = "web-app-subnet"

# EC2
ec2_name_prefix           = "ubuntu"
ec2_instance_count        = 1
ec2_instance_type         = "t3.micro"
ec2_os                    = "ubuntu22"
ec2_key_name              = "devops-tmp"
ec2_enable_public_ip      = true
```

**Scripts**
- `terraform/scripts/install-nginx-https.sh`: user-data usado por la instancia EC2 de ejemplo para instalar nginx y configurar HTTPS (revisar el script si quieres cambiar la configuración de la app).

**Notas y recomendaciones**
- `enable_ssh_from_world` está activado en `test` para facilitar pruebas rápidas; desactívalo en entornos `prod` y usa un bastión o VPN.
- Si necesitas más AZs o subnets privadas, ajusta `availability_zones_to_use` y `create_private_subnets`.
- Revisa y adapta `terraform/backend/*.hcl` si quieres usar un backend remoto (S3 + DynamoDB) antes de `terraform init`.
- No subas ficheros con credenciales (`terraform.tfvars`) a repositorios públicos; usa variables de entorno o un gestor de secretos.

