terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "my_bucket" {
    bucket = "ti-unique-bucket-12345"
    tags = {
    Name        = "MyBucket"
    Environment = "Dev"
    }

    force_destroy = true
}

resource "aws_s3_object" "my_bucket_folder" {
 
  bucket = aws_s3_bucket.my_bucket.id
  key    = "customers/"

  content = ""
}

## create backend

# terraform {
#   backend "s3" {
#     bucket = "ti-tf-state-uploads"
#     key    = "terraform/terraform.tfstate"
#     region = "eu-west-2"
#     profile = "Temidayo"
#   }
# }


locals {
  bucket_folders = flatten([
    for bucket in var.s3_buckets : [
      for folder in var.s3_folders : {
        bucket = bucket
        folder = folder
      }
    ]
  ])

  glue_src_path = "${path.root}/../glue/"
}


# Create multiple s3 buckets

resource "aws_s3_bucket" "s3_buckets" {

    for_each = var.s3_buckets
    
    bucket = "${var.dev_bucket_prefix}-${each.key}-12345"
    tags = {
        Environment = "Dev"
    }

    force_destroy = true
}

resource "aws_s3_object" "folders" {
  for_each = {
    for bf in local.bucket_folders :
    "${bf.folder}" => bf
  }

  bucket = aws_s3_bucket.s3_buckets[each.value.bucket].id
  key    = "${each.value.folder}/"

  content = ""
}

# ## glue service role

# resource "aws_iam_role" "glue_service_role" {
#   name = "glue_service_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "glue.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }


# resource "aws_iam_role_policy" "glue_service_role_policy" {
#   name   = "glue_service_role_policy"
#   role   = aws_iam_role.glue_service_role.name
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "glue:*",
#         "s3:GetBucketLocation",
#         "s3:ListBucket",
#         "s3:ListAllMyBuckets",
#         "s3:GetBucketAcl",
#         "ec2:DescribeVpcEndpoints",
#         "ec2:DescribeRouteTables",
#         "ec2:CreateNetworkInterface",
#         "ec2:DeleteNetworkInterface",
#         "ec2:DescribeNetworkInterfaces",
#         "ec2:DescribeSecurityGroups",
#         "ec2:DescribeSubnets",
#         "ec2:DescribeVpcAttribute",
#         "iam:ListRolePolicies",
#         "iam:GetRole",
#         "iam:GetRolePolicy",
#         "cloudwatch:PutMetricData"
#       ],
#       "Resource": ["*"]
#     },
#     {
#       "Effect": "Allow",
#       "Action": ["s3:CreateBucket"],
#       "Resource": ["arn:aws:s3:::aws-glue-*"]
#     },
#     {
#       "Effect": "Allow",
#       "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
#       "Resource": [
#         "arn:aws:s3:::*/*",
#         "arn:aws:s3:::*/*aws-glue-*/*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": ["s3:GetObject"],
#       "Resource": [
#         "arn:aws:s3:::crawler-public*",
#         "arn:aws:s3:::aws-glue-*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": ["arn:aws:logs:*:*:*:/aws-glue/*"]
#     },
#     {
#       "Effect": "Allow",
#       "Action": ["ec2:CreateTags", "ec2:DeleteTags"],
#       "Condition": {
#         "ForAllValues:StringEquals": {
#           "aws:TagKeys": ["aws-glue-service-resource"]
#         }
#       },
#       "Resource": [
#         "arn:aws:ec2:*:*:network-interface/*",
#         "arn:aws:ec2:*:*:security-group/*",
#         "arn:aws:ec2:*:*:instance/*"
#       ]
#     }
#   ]
# }
# EOF
# }

# ## Glue catalog and crawler

# # Create Glue Data Catalog Database
# resource "aws_glue_catalog_database" "customer-catalog" {
#   name         = "customer-catalog"
#   location_uri = "${aws_s3_bucket.my_bucket.id}/${aws_s3_object.my_bucket_folder.key}"
# }

# # Create Glue Crawler
# resource "aws_glue_crawler" "customer_data" {
#   name          = "customer-data-crawler"
#   database_name = aws_glue_catalog_database.customer-catalog.name
#   role          = aws_iam_role.glue_service_role.name
#   s3_target {
#     path = "${aws_s3_bucket.my_bucket.id}/${aws_s3_object.my_bucket_folder.key}"
#   }
#   schema_change_policy {
#     delete_behavior = "LOG"
#   }
#   configuration = <<EOF
#     {
#       "Version":1.0,
#       "Grouping": {
#         "TableGroupingPolicy": "CombineCompatibleSchemas"
#       }
#     }
#     EOF

#   depends_on = [aws_s3_object.my_bucket_folder]
# }

# resource "aws_glue_trigger" "customer_data_crawler_trigger" {
#   name = "org-report-trigger"
#   type = "ON_DEMAND"
#   actions {
#     crawler_name = aws_glue_crawler.customer_data.name
#   }
# }

########
