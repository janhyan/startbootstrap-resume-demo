# production S3 Bucket
resource "aws_s3_bucket" "production" {
  bucket         = var.s3_buckets[0]
  force_destroy  = true

  tags = {
    Name        = "resume-s3-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "production_public_access" {
  bucket = aws_s3_bucket.production.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "production_website_config" {
  bucket = aws_s3_bucket.production.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "production_versioning" {
  bucket = aws_s3_bucket.production.id

  versioning_configuration {
    status = "Enabled"
  }
}

# CloudFront Origin Access Control for production Bucket
resource "aws_cloudfront_origin_access_control" "production_oac" {
  name                              = "CloudFront S3 OAC"
  description                       = "CloudFront S3 Origin Access Control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution for production Bucket
resource "aws_cloudfront_distribution" "production_distribution" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.production.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.production.id
    origin_access_control_id = aws_cloudfront_origin_access_control.production_oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.production.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "resume-s3-bucket"
  }
}

# IAM Policy Document for production Bucket Access by CloudFront
data "aws_iam_policy_document" "production_s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.production.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.production_distribution.arn]
    }
  }
}

# S3 Bucket Policy for production Bucket
resource "aws_s3_bucket_policy" "production_bucket_policy" {
  bucket = aws_s3_bucket.production.id
  policy = data.aws_iam_policy_document.production_s3_bucket_policy.json
}

# staging S3 Bucket
resource "aws_s3_bucket" "staging" {
  bucket         = var.s3_buckets[1]
  force_destroy  = true

  tags = {
    Name        = "staging-resume-s3-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "staging_public_access" {
  bucket = aws_s3_bucket.staging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "staging_website_config" {
  bucket = aws_s3_bucket.staging.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "staging_versioning" {
  bucket = aws_s3_bucket.staging.id

  versioning_configuration {
    status = "Enabled"
  }
}


# {
#   "Version":"2012-10-17",
#   "Statement":[{
#     "Sid":"PublicReadGetObject",
#     "Effect":"Allow",
#     "Principal": "*",
#     "Action":["s3:GetObject"],
#     "Resource":["arn:aws:s3:::example.com/*"]
#   }]
# }
