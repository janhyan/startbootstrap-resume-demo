output "cloudfront_distribution" {
    value = aws_cloudfront_distribution.production_distribution.id
}