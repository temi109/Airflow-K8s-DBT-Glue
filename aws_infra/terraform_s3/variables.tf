variable "s3_buckets" {
  description = ""
  type = map
  default = {for x in ["terraform"]: x => x}
}

variable "s3_folders" {
  description = ""
  type = map
  default = {for x in ["raw", "processed", "tmpDir"]: x => x}
}


variable "dev_bucket_prefix" {
  type        = string
  description = "Prefix for all S3 buckets"
  default = "ti-dev"
}


variable "s3_bucket" {
  description = ""
  type = string
  default = "glue_job_bucket"
}

variable "project" {
  type=string
  default = "ti-dev-proj"
}

variable "aws_account" {
  type=string
}