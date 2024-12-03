variable "s3_buckets" {
  description = "Bucket names"
  type        = list(string)
  default     = ["bootstrap-resume-v1", "bootstrap-resume-v2"]
}