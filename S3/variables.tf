variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "static-bucket123fl"
}

variable "default_root_object" {
  description = "The default root object for the CloudFront distribution"
  type        = string
  default     = "index.html"
}