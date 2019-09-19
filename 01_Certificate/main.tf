# Default instance of provider
provider "aws" {
}

terraform {
    # Optional
    # Terraform backend configuration. The state is stored in S3 bucket
    # The actions to do are calculated from a diff of current infra and backend state
    # Is read on the very early stage, so using variables are not allowed
    backend "s3" {
        key = "Website_BackendCertificate/state.tfstate"
    }
}


module "certificate_staging" {
  source            = "../modules/certificate"
  domain_name       = "${var.domain_name}"
  subdomain_name    = "api-staging"
}

module "certificate_prod" {
  source            = "../modules/certificate"
  domain_name       = "${var.domain_name}"
  subdomain_name    = "api"
}