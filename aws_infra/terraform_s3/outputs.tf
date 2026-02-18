

output "glue_usage_bucket" {
  description = "Name of the dbt glue usage bucket"
  value       = aws_s3_bucket.dbt_glue_usage_bucket.id
}


output "dbt_glue_role_arn" {
  description = "Arn of the glue role"
  value       = aws_iam_role.dbt_glue_role.arn
}
