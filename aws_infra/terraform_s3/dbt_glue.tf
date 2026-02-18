

resource "aws_s3_bucket" "dbt_glue_database_bucket" {
    bucket = "ti-dbt-glue-database-bucket-12345"
    tags = {
    Name        = "MyBucket"
    Environment = "Dev"
    }

    force_destroy = true
}


resource "aws_s3_object" "dbt_glue_db_source_folder" {
 
  bucket = aws_s3_bucket.dbt_glue_database_bucket.id
  key    = "glue-db-source/"

  content = ""
}

resource "aws_s3_object" "dbt_glue_db_output_folder" {
 
  bucket = aws_s3_bucket.dbt_glue_database_bucket.id
  key    = "glue-db-output/"

  content = ""
}


resource "aws_s3_bucket" "dbt_glue_usage_bucket" {
    bucket = "ti-dbt-glue-usage-bucket-12345"
    tags = {
    Name        = "MyBucket"
    Environment = "Dev"
    }

    force_destroy = true
}


resource "aws_s3_object" "dbt_glue_usage_source_folder" {
 
  bucket = aws_s3_bucket.dbt_glue_usage_bucket.id
  key    = "source/"

  content = ""
}

resource "aws_s3_object" "dbt_glue_usage_output_folder" {
 
  bucket = aws_s3_bucket.dbt_glue_usage_bucket.id
  key    = "output/"

  content = ""
}


## Create dbt source database

resource "aws_glue_catalog_database" "dbt_glue_source_database" {
  name        = "dbt_glue_source_database"
  description = "Glue database for analytics datasets"

  location_uri = "${aws_s3_bucket.dbt_glue_database_bucket.id}/${aws_s3_object.dbt_glue_db_source_folder.key}"

  tags = {
    Environment = "dev"
    Owner       = "data-platform"
  }
}

## Create dbt output database

resource "aws_glue_catalog_database" "dbt_glue_output_database" {
  name        = "dbt_glue_output_database"
  description = "Glue database for analytics datasets"

  location_uri = "${aws_s3_bucket.dbt_glue_database_bucket.id}/${aws_s3_object.dbt_glue_db_output_folder.key}"

  tags = {
    Environment = "dev"
    Owner       = "data-platform"
  }
}

