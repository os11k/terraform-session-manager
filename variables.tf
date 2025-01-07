variable "aws_region" {
  type        = string
  description = "AWS Region where the provider will operate. The Region must be set."
  default     = "us-east-1"
}

variable "ssm_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

variable "s3_bucket" {
  type        = string
  description = "Name of the S3 bucket for S3 server side logging of session manager sessions"
  default     = "ssm-logging"
}
