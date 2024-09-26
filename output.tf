# output "az_info" {
#     value = data.aws_availability_zones.AZ
# }
# output "default_vpc" {
#   value = data.aws_vpc.default
# }
output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
output "private_subent_ids" {
  value = aws_subnet.private[*].id
}
output "db_subnet_ids" {
  value = aws_subnet.database[*].id
}