# output "target_group_arn" {
#   description = "ARN of the ALB target group"
#   value       = aws_lb_target_group.app.arn
# }

# # output "alb_security_group_id" {
# #   description = "ID of the ALB security group"
# #   value       = aws_security_group.cloudfront_sg.id
# # }
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_name" {
  value = aws_lb.alb.name
}