terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region


  #floci configuration :remove these for real AWS
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    sts = "http://localhost:4566"
    s3  = "http://localhost:4566"
    iam = "http://localhost:4566"
    ec2 = "http://localhost:4566"
    eks = "http://localhost:4566"
  }
}