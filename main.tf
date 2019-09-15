# Default instance of provider
provider "aws" {
}

terraform {
    # Optional
    # Terraform backend configuration. The state is stored in S3 bucket
    # The actions to do are calculated from a diff of current infra and backend state
    # Is read on the very early stage, so using variables are not allowed
    backend "s3" {
        key = "Website_Backend/state.tfstate"
    }
}

resource "aws_s3_bucket" "web_site_bucket" {
  bucket = "${var.source_bucket_name}"
  
  force_destroy = true
}