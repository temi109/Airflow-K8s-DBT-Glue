data "aws_iam_policy_document" "glue_execution_assume_role_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "data_lake_policy" {

  statement {

    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket}/*"]

    actions = ["s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket}/",
                 "arn:aws:s3:::awsglue-datasets/"]

    actions = ["s3:ListBucket"]
  }

   statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::awsglue-datasets/*"]

    actions = ["s3:GetObject"]
  }
}

resource "aws_iam_policy" "data_lake_access_policy" {
  name        = "s3DataLakePolicy-${var.s3_bucket}"
  description = "allows for running glue job in the glue console and access my s3_bucket"
  policy      = data.aws_iam_policy_document.data_lake_policy.json
#   tags = {
#     Application = var.project
#   }
}


resource "aws_iam_role" "glue_service_role" {
name = "aws_glue_job_runner"
assume_role_policy = data.aws_iam_policy_document.glue_execution_assume_role_policy.json
# tags = {
# Application = var.project
# }
}

resource "aws_iam_role_policy_attachment" "data_lake_permissions" {
  role = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.data_lake_access_policy.arn
}


### Create policy for dbt glue

# Create the Glue IAM role.


resource "aws_iam_role" "dbt_glue_role" {
  name = "dbt_glue_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "dbt_glue_permissions" {
  name = "dbt_glue_permissions"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ReadAndWriteDatabases",
            "Action": [
                "glue:SearchTables",
                "glue:BatchCreatePartition",
                "glue:CreatePartitionIndex",
                "glue:DeleteDatabase",
                "glue:GetTableVersions",
                "glue:GetPartitions",
                "glue:DeleteTableVersion",
                "glue:UpdateTable",
                "glue:DeleteTable",
                "glue:DeletePartitionIndex",
                "glue:GetTableVersion",
                "glue:UpdateColumnStatisticsForTable",
                "glue:CreatePartition",
                "glue:UpdateDatabase",
                "glue:CreateTable",
                "glue:GetTables",
                "glue:GetDatabases",
                "glue:GetTable",
                "glue:GetDatabase",
                "glue:GetPartition",
                "glue:UpdateColumnStatisticsForPartition",
                "glue:CreateDatabase",
                "glue:BatchDeleteTableVersion",
                "glue:BatchDeleteTable",
                "glue:DeletePartition",
                "glue:GetUserDefinedFunctions",
                "lakeformation:ListResources",
                "lakeformation:BatchGrantPermissions",
                "lakeformation:ListPermissions", 
                "lakeformation:GetDataAccess",
                "lakeformation:GrantPermissions",
                "lakeformation:RevokePermissions",
                "lakeformation:BatchRevokePermissions",
                "lakeformation:AddLFTagsToResource",
                "lakeformation:RemoveLFTagsFromResource",
                "lakeformation:GetResourceLFTags",
                "lakeformation:ListLFTags",
                "lakeformation:GetLFTag",
            ],
            "Resource": [
                "arn:aws:glue:eu-west-2:${var.aws_account}:catalog",
                "arn:aws:glue:eu-west-2:${var.aws_account}:table/${aws_glue_catalog_database.dbt_glue_output_database.name}/*",
                "arn:aws:glue:eu-west-2:${var.aws_account}:database/${aws_glue_catalog_database.dbt_glue_output_database.name}",
                "arn:aws:glue:eu-west-2:${var.aws_account}:table/*",
                "arn:aws:glue:eu-west-2:${var.aws_account}:database/*"
            ],
            "Effect": "Allow"
        },
        {
            "Sid": "ReadOnlyDatabases",
            "Action": [
                "glue:SearchTables",
                "glue:GetTableVersions",
                "glue:GetPartitions",
                "glue:GetTableVersion",
                "glue:GetTables",
                "glue:GetDatabases",
                "glue:GetTable",
                "glue:GetDatabase",
                "glue:GetPartition",
                "lakeformation:ListResources",
                "lakeformation:ListPermissions"
            ],
            "Resource": [
                "arn:aws:glue:eu-west-2:${var.aws_account}:table/${aws_glue_catalog_database.dbt_glue_source_database.name}/*",
                "arn:aws:glue:eu-west-2:${var.aws_account}:database/${aws_glue_catalog_database.dbt_glue_source_database.name}",
                "arn:aws:glue:eu-west-2:${var.aws_account}:table/*",
                "arn:aws:glue:eu-west-2:${var.aws_account}:database/*",
                "arn:aws:glue:eu-west-2:${var.aws_account}:database/default",
                "arn:aws:glue:eu-west-2:${var.aws_account}:database/global_temp"
            ],
            "Effect": "Allow"
        },
        {
            "Sid": "StorageAllBuckets",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.dbt_glue_database_bucket.id}/${aws_s3_object.dbt_glue_usage_output_folder.key}",
                "arn:aws:s3:::${aws_s3_bucket.dbt_glue_database_bucket.id}/${aws_s3_object.dbt_glue_usage_source_folder.key}"
            ],
            "Effect": "Allow"
        },
        {
            "Sid": "ReadAndWriteBuckets",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.dbt_glue_database_bucket.id}/${aws_s3_object.dbt_glue_usage_output_folder.key}",
                "arn:aws:s3:::${aws_s3_bucket.dbt_glue_database_bucket.id}/*"
            ],
            "Effect": "Allow"
        },
        {
            "Sid": "ReadOnlyBuckets",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.dbt_glue_database_bucket.id}/${aws_s3_object.dbt_glue_usage_source_folder.key}",
                "arn:aws:s3:::${aws_s3_bucket.my_bucket.id}/*"
            ],
            "Effect": "Allow"
        }
    ]
})

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_role_policy_attachment" "dbt_glue_attach" {
  role       = aws_iam_role.dbt_glue_role.name
  policy_arn = aws_iam_policy.dbt_glue_permissions.arn
}