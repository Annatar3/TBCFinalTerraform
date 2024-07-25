## Description
This repository contains Terraform configurations to provision various AWS resources including ALB, ECS, ECR, RDS, CloudFront, S3, VPC, and more according to Filuet AM website needs on AWS. The configuration is modularized to facilitate easy management and deployment of infrastructure components.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |


## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_module"></a> [alb\_module](#module\_alb\_module) | ./ALB | n/a |
| <a name="module_backend_cloudfront"></a> [backend\_cloudfront](#module\_backend\_cloudfront) | ./CloudfrontECS | n/a |
| <a name="module_ecr_module"></a> [ecr\_module](#module\_ecr\_module) | ./ECR | n/a |
| <a name="module_ecs_module"></a> [ecs\_module](#module\_ecs\_module) | ./ECS | n/a |
| <a name="module_main"></a> [main](#module\_main) | ./VPC | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ./RDS | n/a |

## Resources

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_module"></a> [alb\_module](#module\_alb\_module) | ./ALB | n/a |
| <a name="module_backend_cloudfront"></a> [backend\_cloudfront](#module\_backend\_cloudfront) | ./CloudfrontECS | n/a |
| <a name="module_ecr_module"></a> [ecr\_module](#module\_ecr\_module) | ./ECR | n/a |
| <a name="module_ecs_module"></a> [ecs\_module](#module\_ecs\_module) | ./ECS | n/a |
| <a name="module_main"></a> [main](#module\_main) | ./VPC | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ./RDS | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ALB_DOMAIN"></a> [ALB\_DOMAIN](#input\_ALB\_DOMAIN) | The domain name of ALB | `string` | n/a | yes |
| <a name="input_ALB_TAGS"></a> [ALB\_TAGS](#input\_ALB\_TAGS) | n/a | `list` | n/a | yes |
| <a name="input_ALIAS_CF"></a> [ALIAS\_CF](#input\_ALIAS\_CF) | n/a | `list(any)` | n/a | yes |
| <a name="input_CF_REGION"></a> [CF\_REGION](#input\_CF\_REGION) | ## CloudFront ### | `string` | n/a | yes |
| <a name="input_CF_TAGS"></a> [CF\_TAGS](#input\_CF\_TAGS) | n/a | `list` | n/a | yes |
| <a name="input_CIDR"></a> [CIDR](#input\_CIDR) | n/a | `string` | n/a | yes |
| <a name="input_DOMAIN"></a> [DOMAIN](#input\_DOMAIN) | alb domain | `string` | n/a | yes |
| <a name="input_ECR_TAGS"></a> [ECR\_TAGS](#input\_ECR\_TAGS) | n/a | `list` | n/a | yes |
| <a name="input_ENVIRONMENT_NAME"></a> [ENVIRONMENT\_NAME](#input\_ENVIRONMENT\_NAME) | ## VPC ### | `string` | n/a | yes |
| <a name="input_RDS_TAGS"></a> [RDS\_TAGS](#input\_RDS\_TAGS) | ## RDS ### | `list` | n/a | yes |
| <a name="input_REGION"></a> [REGION](#input\_REGION) | n/a | `string` | n/a | yes |
| <a name="input_VPC_TAGS"></a> [VPC\_TAGS](#input\_VPC\_TAGS) | n/a | `list` | n/a | yes |
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Name of the ALB | `string` | n/a | yes |
| <a name="input_alb_security_group_id"></a> [alb\_security\_group\_id](#input\_alb\_security\_group\_id) | ID of the ALB security group | `string` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the SSL certificate | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container | `string` | n/a | yes |
| <a name="input_ecr_repository_name"></a> [ecr\_repository\_name](#input\_ecr\_repository\_name) | The name of the ECR repository | `string` | n/a | yes |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | Name of the ECS cluster | `string` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | Name of the ECS service | `string` | n/a | yes |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | Health check interval for the target group | `number` | n/a | yes |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health check path for the target group | `string` | n/a | yes |
| <a name="input_health_check_port"></a> [health\_check\_port](#input\_health\_check\_port) | Health check port for the target group | `string` | n/a | yes |
| <a name="input_health_check_protocol"></a> [health\_check\_protocol](#input\_health\_check\_protocol) | Health check protocol for the target group | `string` | n/a | yes |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | Health check timeout for the target group | `number` | n/a | yes |
| <a name="input_healthy_threshold"></a> [healthy\_threshold](#input\_healthy\_threshold) | Healthy threshold for the target group | `number` | n/a | yes |
| <a name="input_rds_engine"></a> [rds\_engine](#input\_rds\_engine) | The engine type for the RDS instance | `string` | n/a | yes |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | The engine version for the RDS instance | `string` | n/a | yes |
| <a name="input_rds_identifier"></a> [rds\_identifier](#input\_rds\_identifier) | The identifier for the RDS instance | `string` | n/a | yes |
| <a name="input_rds_instance_type"></a> [rds\_instance\_type](#input\_rds\_instance\_type) | The instance type for the RDS instance | `string` | n/a | yes |
| <a name="input_rds_max_allocated_storage"></a> [rds\_max\_allocated\_storage](#input\_rds\_max\_allocated\_storage) | The maximum allocated storage for the RDS instance | `number` | n/a | yes |
| <a name="input_rds_min_allocated_storage"></a> [rds\_min\_allocated\_storage](#input\_rds\_min\_allocated\_storage) | The minimum allocated storage for the RDS instance | `number` | n/a | yes |
| <a name="input_rds_password"></a> [rds\_password](#input\_rds\_password) | The password for the RDS instance | `string` | n/a | yes |
| <a name="input_rds_security_group_ids"></a> [rds\_security\_group\_ids](#input\_rds\_security\_group\_ids) | The security group IDs for the RDS instance | `list(string)` | n/a | yes |
| <a name="input_rds_storage_type"></a> [rds\_storage\_type](#input\_rds\_storage\_type) | The storage type for the RDS instance | `string` | n/a | yes |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | The username for the RDS instance | `string` | n/a | yes |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | ARN of the ALB target group | `string` | n/a | yes |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Name of the target group | `string` | n/a | yes |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | Port for the target group | `number` | n/a | yes |
| <a name="input_task_definition_compatibilities"></a> [task\_definition\_compatibilities](#input\_task\_definition\_compatibilities) | Compatibilities of the ECS task definition | `list(string)` | n/a | yes |
| <a name="input_task_definition_cpu"></a> [task\_definition\_cpu](#input\_task\_definition\_cpu) | CPU units for the ECS task definition | `number` | n/a | yes |
| <a name="input_task_definition_family"></a> [task\_definition\_family](#input\_task\_definition\_family) | Family name of the ECS task definition | `string` | n/a | yes |
| <a name="input_task_definition_memory"></a> [task\_definition\_memory](#input\_task\_definition\_memory) | Memory for the ECS task definition | `number` | n/a | yes |
| <a name="input_unhealthy_threshold"></a> [unhealthy\_threshold](#input\_unhealthy\_threshold) | Unhealthy threshold for the target group | `number` | n/a | yes |
| <a name="input_volume_name"></a> [volume\_name](#input\_volume\_name) | Volume name for the ECS task definition | `string` | n/a | yes |

## Usage
Setup
Clone the repository:

git clone https://github.com/iamops-team/filuet-terraform
cd filuet-terraform

Initialize Terraform:

terraform init
Modify variables:

Update variables.tf and tfvars files with your specific configuration values.

Examples
Provisioning Infrastructure
To provision the infrastructure defined in this repository, follow these steps:

Plan the execution:

terraform plan -out=tfplan -var-file="./tfvars/vars.tfvars"
Or if you want to give variable values through prompt
terraform plan -out=tfplan

Apply the configuration:

terraform apply tfplan

