# ==================== modules/network/variables.tf ====================

variable "Project"              { type = string }
variable "vpc_name"             { type = string }
variable "Environment"          { type = string }
variable "Region"               { 
    type = string
    default = "us-east-1"
}
variable "vpc_cidr"             { 
    type = string
    default = "10.0.0.0/16"
}
variable "availability_zones_to_use" {
  description = "Número de AZs a usar (1–6)"
  type        = number
  default     = 2
}
variable "ipv6_support" {
  type    = bool
  default = false
}
variable "nat_gateway_configuration" {
  description = "'none' (sin NAT), 'single' (recomendado prod), 'one_per_az' (máxima HA pero caro)"
  type        = string
  default     = "single"
  validation {
    condition     = contains(["none", "single", "one_per_az"], var.nat_gateway_configuration)
    error_message = "Valores permitidos: none, single, one_per_az"
  }
}
variable "create_public_subnets"  {
    type = bool
    default = true
}
variable "create_private_subnets" {
    type = bool
    default = true
}

# Opcional: CIDRs manuales para casos avanzados
variable "public_subnet_cidrs"  {
    type = list(string)
    default = null
}
variable "private_subnet_cidrs" {
    type = list(string)
    default = null
}

# Seguridad: se puede sobreescribir desde fuera
variable "allowed_ingress_cidr" {
  description = "CIDR desde donde permitir acceso (por defecto solo VPC)"
  type        = string
  default     = null
}
variable "enable_ssh_from_world" {
    type = bool
    default = false
}
variable "enable_https_from_world" {
    type = bool
    default = true
}
variable "force_public_subnet_name" {
  description = "Si se define, SOBRESCRIBE el nombre de TODAS las subnets públicas"
  type        = string
  default     = null
}