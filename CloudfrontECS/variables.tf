variable "CF_REGION" {
  type        = string
}

# variable "ALB_DOMAIN" {
#   type        = string
# }


variable "ENVIRONMENT_NAME" {
  type        = string
}

variable "DOMAIN" {
  description = "The domain name for the CloudFront distribution"
  type        = string
}

variable "ALIAS_CF" {
  type = list(any)
}

variable "TAGS" {
    type = list
}

variable "ALB_DOMAIN" {
  description = "The domain name of ALB"
  type        = string
}