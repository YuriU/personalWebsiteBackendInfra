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

module "source_bucket" {
  source = "./modules/source_bucket"
  name = "${var.download_source_bucket_name}"
}

module "counter_table" {
  source            = "./modules/dynamo_db_table"
  name              = "${var.application_name}_FileDownloadCount"
  partitionKey      = "FileName"
  partitionKeyType  = "S"
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.lambda_exec.name}"
  policy_arn = "${module.source_bucket.read_only_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "test-attach2" {
  role       = "${aws_iam_role.lambda_exec.name}"
  policy_arn = "${module.counter_table.read_write_policy_arn}"
}

resource "aws_lambda_function" "function" {
  function_name = "${var.application_name}"
  handler       = "personalWebsiteBackend::personalWebsiteBackend.RequestHandler::HandleRequest"
  runtime       = "dotnetcore2.1"

  filename      = "empty_lambda_folder.zip"

  timeout = 30
  memory_size = 256
  role = "${aws_iam_role.lambda_exec.arn}"

  environment {
    variables = {
      SourceBucket_Name     = "${module.source_bucket.bucket_name}"
      SourceBucket_FileName = "${var.download_source_default_file_name}"
      Database_CounterTable = "${module.counter_table.table_name}"
    }
  }
}

resource "aws_api_gateway_rest_api" "gateway" {
  name        = "${var.application_name}"
  description = "Terraform Managed for ${var.application_name}"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  binary_media_types = ["application/msword"]
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.gateway.root_resource_id}"
  path_part   = "Hello"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.function.invoke_arn}"

  content_handling = "CONVERT_TO_BINARY"
}


resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  stage_name  = "default"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.gateway.execution_arn}/*/*/*"
}


output "base_url" {
  value = "${aws_api_gateway_deployment.api.invoke_url}"
}