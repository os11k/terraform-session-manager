terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

#### Create the instance profile

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-ec2-profile"
  role = aws_iam_role.ssm_role.name
}
