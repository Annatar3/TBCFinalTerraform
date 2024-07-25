#---------- CloudFront Distribution -------------

#provided external provider to create resource in US
provider "aws" {
  alias  = "filuet-prod"
  region = var.CF_REGION
}

#Certificate = spinomenal.io
data "aws_acm_certificate" "certificate_issued" {
  provider = aws.filuet-prod
  domain   = var.DOMAIN
  statuses = ["ISSUED"]
}

# WAF for the CloudFront
# data "aws_wafv2_web_acl" "web_acl" {
#   name  = var.WEB_ACL_NAME
#   scope = "CLOUDFRONT"
# }

#ALB DNS name
# data "aws_lb" "alb_dns" {
#   name = var.EXTERNAL_ALB_NAME
# }

#Create CloudFront function
# resource "aws_cloudfront_function" "ForwardIPs" {
#   name    = "${var.ENVIRONMENT_NAME}-ForwardIPs"
#   runtime = "cloudfront-js-1.0"
#   comment = "This is used to add trueclientip header in incoming request"
#   publish = true
#   code    = file("./test.js")
# }
# data "aws_lb" "alb" {
#   name = module.backend_cloudfront.alb_name
# }

#Create CloudFront distribution
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  provider = aws.filuet-prod

  origin {
    domain_name = var.ALB_DOMAIN
    # domain_name = data.aws_lb.alb_dns.lb_dns_name
    origin_id   = "${var.ENVIRONMENT_NAME}-web-CDN"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2"
  # web_acl_id      = "b0798e0c-a385-48a4-8a2c-87fac2afc5b7"
  # web_acl_id      = data.aws_wafv2_web_acl.web_acl.arn
  comment         = "CloudFront distribution for external ALB"

  aliases = var.ALIAS_CF

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    target_origin_id       = "${var.ENVIRONMENT_NAME}-web-CDN"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
    # function_association {
    #   event_type   = "viewer-request"
    #   function_arn = aws_cloudfront_function.ForwardIPs.arn
    # }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.certificate_issued.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  price_class = "PriceClass_All"

  tags = {
    Name = "${var.ENVIRONMENT_NAME}-web-CDN"
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}
