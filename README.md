# Terraform Session Manager Module

This module configures the necessary IAM roles, an S3 bucket, and other resources required to enable login to your EC2 instances using AWS Session Manager. Note that you will still need to create an `aws_ssm_document`, as shown in the example below.

## Usage

```terraform
module "ssm" {
  source = "../modules/ssm"
}

provider "aws" {
  region  = "us-east-1"
  profile = "my-profile-name"
  alias   = "useast1"
}

resource "aws_ssm_document" "session_manager_prefs_useast1" {
  provider = aws.useast1

  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = <<DOC
{
    "schemaVersion": "1.0",
    "description": "SSM document to house preferences for session manager",
    "sessionType": "Standard_Stream",
    "inputs": {
        "s3BucketName": "${module.ssm.ssm_s3_bucket_id}",
        "s3KeyPrefix": "AWSLogs/ssm_session_logs",
        "s3EncryptionEnabled": true,
        "cloudWatchLogGroupName": "",
        "runAsEnabled": true,
        "runAsDefaultUser": "${var.user}",
        "shellProfile": {
          "windows": "",
          "linux": "exec /bin/bash\ncd /home/${var.user}"
        },
        "idleSessionTimeout": "20"
    }
}
DOC
}
```

This configuration sets up Session Manager for the us-east-1 region. A separate configuration is required for each additional region.

## Adding Another Region

To add support for an additional region, such as us-east-2, include the following code snippet:

```terraform
provider "aws" {
  region  = "us-east-2"
  profile = "my-profile-name"
  alias   = "useast2"
}

resource "aws_ssm_document" "session_manager_prefs_useast1" {
  provider = aws.useast2

  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = <<DOC
{
    "schemaVersion": "1.0",
    "description": "SSM document to house preferences for session manager",
    "sessionType": "Standard_Stream",
    "inputs": {
        "s3BucketName": "${module.ssm.ssm_s3_bucket_id}",
        "s3KeyPrefix": "AWSLogs/ssm_session_logs",
        "s3EncryptionEnabled": true,
        "cloudWatchLogGroupName": "",
        "runAsEnabled": true,
        "runAsDefaultUser": "${var.user}",
        "shellProfile": {
          "windows": "",
          "linux": "exec /bin/bash\ncd /home/${var.user}"
        },
        "idleSessionTimeout": "20"
    }
}
DOC
}
```

Repeat this process for each additional region by adjusting the provider alias and region-specific configurations.

## Configuration Details

You can find more information about the input parameters and options available for `aws_ssm_document` in the official AWS documentation:  
**[AWS Systems Manager - Session Manager Schema](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-schema.html)**

## Additional Resources

For a more in-depth explanation and practical examples, check out the blog post here:  
**[Exploring AWS Systems Manager Session Manager](https://blog.volunge.net/jekyll/update/2025/01/07/aws-systems-manager-session-manager.html)**
