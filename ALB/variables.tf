variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "TAGS" {
    type = list
}

variable "DOMAIN" {
  description = "Name of domain"
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
}

variable "health_check_interval" {
  description = "Health check interval for the target group"
  type        = number
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
}

variable "health_check_port" {
  description = "Health check port for the target group"
  type        = string
}

variable "health_check_protocol" {
  description = "Health check protocol for the target group"
  type        = string
}

variable "health_check_timeout" {
  description = "Health check timeout for the target group"
  type        = number
}

variable "healthy_threshold" {
  description = "Healthy threshold for the target group"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Unhealthy threshold for the target group"
  type        = number
}
