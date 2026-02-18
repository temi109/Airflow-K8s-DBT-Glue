resource "aws_s3_bucket" "athena_bucket" {
    bucket = "ti-athena-bucket-12345"
    tags = {
    Name        = "MyBucket"
    Environment = "Dev"
    }

    force_destroy = true
}

resource "aws_s3_object" "athena_bucket_folder" {
 
  bucket = aws_s3_bucket.athena_bucket.id
  key    = "resultsdir/"

  content = ""
}