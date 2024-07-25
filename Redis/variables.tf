variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "cluster_id" {
  description = "The name of the cluster"
  type        = string
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes"
  type        = string
  default     = "cache.t2.micro"
}

variable "num_cache_nodes" {
  description = "The number of cache nodes the cluster should have"
  type        = number
  default     = 1
}

variable "port" {
  description = "The port number on which each of the cache nodes will accept connections"
  type        = number
  default     = 6379
}

# variable "private_az1" {
#   type = string
# }

# variable "private_az2" {
#   type = string
# }