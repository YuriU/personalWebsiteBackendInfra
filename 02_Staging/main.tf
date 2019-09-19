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
  source                    = "../modules/lambda"
  application_name          = "mytestlambda"
  attached_policies         = ["${module.counter_table.read_write_policy_arn}", "${module.source_bucket.read_only_policy_arn}"]
  attached_policies_count   = 2,
  lambda_bin_file_name      = "empty_lambda_folder.zip"
  entry_point               = "personalWebsiteBackend::personalWebsiteBackend.RequestHandler::HandleRequest"
  environment_variables     = {
      SourceBucket_Name     = "${module.source_bucket.bucket_name}"
      SourceBucket_FileName = "${var.download_source_default_file_name}"
      Database_CounterTable = "${module.counter_table.table_name}"
  }
}

module "api_gateway" {
  source                = "../modules/api_gateway"
  application_name      = "mytestlambda"
  path_part             = "Hello"
  lambda_invoke_arn     = "${module.lambda.invoke_arn}"
  lambda_function_name  = "${module.lambda.function_name}"
  binary_media_types    = ["*/*"]
}

module "domain-mapping" {
  source                = "../modules/domain_mapping"
  domain_name           = "${var.domain_name}"
  subdomain_name        = "${var.subdomain_name}" 
  api_gateway_id        = "${module.api_gateway.api_gateway_id}"
  api_deployment_stage     = "${module.api_gateway.api_deployment_stage}"
}

output "base_url" {
  value = "${module.api_gateway.base_url}"
}
