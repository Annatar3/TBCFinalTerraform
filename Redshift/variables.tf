variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "cluster_identifier" {
  description = "The Redshift cluster identifier."
  type        = string
}

variable "node_type" {
  description = "The node type for the Redshift cluster."
  type        = string
}

variable "number_of_nodes" {
  description = "The number of nodes in the Redshift cluster."
  type        = number
}

variable "database_name" {
  description = "The database name for the Redshift cluster."
  type        = string
}

variable "master_username" {
  description = "The master username for the Redshift cluster."
  type        = string
}

variable "master_password" {
  description = "The master password for the Redshift cluster."
  type        = string
}

variable "port" {
  description = "The port to connect to the Redshift cluster."
  type        = number
  default     = 5439
}

# variable "vpc_security_group_ids" {
#   description = "List of VPC security group IDs to associate with the cluster."
#   type        = list(string)
# }

# variable "subnet_group_name" {
#   description = "The subnet group name for the Redshift cluster."
#   type        = string
# }
