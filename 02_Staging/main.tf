# Default instance of provider
provider "aws" {
}

terraform {
    # Optional
    # Terraform backend configuration. The state is stored in S3 bucket
    # The actions to do are calculated from a diff of current infra and backend state
    # Is read on the very early stage, so using variables are not allowed
    backend "s3" {
        key = "Website_BackendStaging/state.tfstate"
    }
}



module "source_bucket" {
  source = "../modules/source_bucket"
  name = "${var.download_source_bucket_name}"
}

module "counter_table" {
  source            = "../modules/dynamo_db_table"
  name              = "${var.application_name}_FileDownloadCount"
  partitionKey      = "FileName"
  partitionKeyType  = "S"
}

module "lambda" {
  source = "../modules/lambda"
  application_name = "mytestlambda"
  attached_policies = ["${module.counter_table.read_write_policy_arn}", "${module.source_bucket.read_only_policy_arn}"]
}
