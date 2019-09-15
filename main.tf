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

resource "aws_lambda_function" "function" {
  function_name = "${var.application_name}"

  # The bucket name as created earlier with "aws s3api create-bucket"
    # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler       = "personalWebsiteBackend::personalWebsiteBackend.RequestHandler::HandleRequest"
  runtime       = "dotnetcore2.1"

  filename      = "empty_lambda_folder.zip"

  #s3_bucket = "${aws_s3_bucket.pipeline.bucket}"
  #s3_key    = "v1.0.0/example.zip"

  timeout = 30
  memory_size = 128
  role = "${aws_iam_role.lambda_exec.arn}"

  environment {
    variables = {
      SourceBucket_Name     = "${module.source_bucket.bucket_name}"
      SourceBucket_FileName = "${var.download_source_default_file_name}"
    }
  }
}