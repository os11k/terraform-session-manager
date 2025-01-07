output "ssm-profile-name" {
  value = aws_iam_instance_profile.ssm_profile.name
}

output "ssm_s3_bucket_id" {
  value = aws_s3_bucket.ssm_s3_bucket.id
}
