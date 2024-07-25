resource "aws_ecr_repository" "ecr" {
    name = var.ecr_repository_name
    tags = {
      Name = var.ENVIRONMENT_NAME
      Environment = var.TAGS[0].Environment
      Tier = var.TAGS[0].Tier
      Role = var.TAGS[0].Role
    }
}