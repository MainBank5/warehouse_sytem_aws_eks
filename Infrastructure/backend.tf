terraform {
  backend "s3" {
    bucket       = "eliud-terraform-state-unique-2026" #the actual name of the bucket . but avoid hardcoding it nstead take from the output and run it n the int command 
    key          = "infrastructure/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

    endpoints = {
      s3 = "http://localhost:4566"
    }

    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
  }
}