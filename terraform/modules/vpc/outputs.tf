# ==================== modules/network/outputs.tf ====================

output "vpc_id"                    { value = aws_vpc.main.id }
output "vpc_cidr"                  { value = aws_vpc.main.cidr_block }
output "public_subnets"            { value = var.create_public_subnets ? aws_subnet.public[*].id : [] }
output "private_subnets"           { value = var.create_private_subnets ? aws_subnet.private[*].id : [] }
output "public_security_group_id"  { value = aws_security_group.public_sg.id }
output "private_security_group_id" { value = aws_security_group.private_sg.id }
output "nat_gateway_ids"           { value = local.create_nat ? aws_nat_gateway.nat[*].id : [] }
output "internet_gateway_id"       { value = var.create_public_subnets ? aws_internet_gateway.igw[0].id : null }