#------------S3 CloudFront---------------
resource "aws_cloudfront_origin_access_identity" "s3_origin_access_identity" {
  comment = "Origin Access Identity"
}

data "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.s3_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = var.bucket_name
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_distribution" "s3_cloudfront" {
  origin {
    domain_name = data.aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id   = data.aws_s3_bucket.s3_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = var.default_root_object

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = data.aws_s3_bucket.s3_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
