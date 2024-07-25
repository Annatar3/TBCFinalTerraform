# output "private_subnet_id1" {
#   value = aws_subnet.private_az1.id
# }

# output "private_subnet_id2" {
#   value = aws_subnet.private_az2.id
# }
output "vpc_name" {
  value = var.ENVIRONMENT_NAME
}