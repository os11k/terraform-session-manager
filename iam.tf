#### Create the IAM role for the instance profile ####

resource "aws_iam_role" "ssm_role" {
  name = "SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2AssumeRole"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#### Create Policy to allow instance profile to put objects in the S3 bucket ####

resource "aws_iam_policy" "ec2_policy" {
  name        = "ssm_logs_policy"
  description = "Policy allowing put and get operations for ec2 to place session logs in specified bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "s3:GetEncryptionConfiguration",
        Resource = "${aws_s3_bucket.ssm_s3_bucket.arn}"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"

        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.ssm_s3_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "s3_attach" {
  name       = "ssm-s3-put"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn

}

#### Attach AWS and Customer managed policies to the IAM role ####

resource "aws_iam_policy_attachment" "ssm-attach" {
  name       = "managed-ssm-policy-attach"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = var.ssm_policy_arn
}
