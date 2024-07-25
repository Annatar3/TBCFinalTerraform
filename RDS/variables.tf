variable "TAGS" {
    type = list
}

variable "ENVIRONMENT_NAME" {
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "CIDR" {
  description = "CIDR block for the VPC"
  default     = "10.100.0.0/16"
}

variable "IDENTIFIER" {
  description = "The identifier for the DB instance"
  type        = string
}

variable "ENGINE" {
  description = "The database engine to use"
  type        = string
}

variable "ENGINE_VERSION" {
  description = "The version of the database engine"
  type        = string
}

variable "DB_INSTANCE_TYPE" {
  description = "The instance type of the RDS"
  type        = string
}

variable "MIN_ALLOCATED_STORAGE" {
  description = "The minimum allocated storage for the RDS instance"
  type        = number
}

variable "MAX_ALLOCATED_STORAGE" {
  description = "The maximum allocated storage for the RDS instance"
  type        = number
}

variable "STORAGE_TYPE" {
  description = "The storage type to use for the RDS instance"
  type        = string
}

variable "RDS_SG" {
  description = "List of VPC security groups to associate with the RDS instance"
  type        = list(string)
}

variable "DB_USERNAME" {
  description = "The username for the RDS instance"
  type        = string
}

variable "Password" {
  description = "The username for the RDS instance"
  type        = string
}