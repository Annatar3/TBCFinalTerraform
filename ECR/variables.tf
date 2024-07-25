variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "ENVIRONMENT_NAME" {
  type        = string
}

variable "TAGS" {
    type = list
}