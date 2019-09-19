resource "aws_iam_role" "lambda_role" {
  name = "${var.application_name}"

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

resource "aws_iam_role_policy_attachment" "role_policies_attachments" {
  role       = "${aws_iam_role.lambda_role.name}"
  count      = "${length(var.attached_policies)}"
  policy_arn = "${var.attached_policies[count.index]}"
}

resource "aws_lambda_function" "function" {
  function_name = "${var.application_name}"
  handler       = "personalWebsiteBackend::personalWebsiteBackend.RequestHandler::HandleRequest"
  runtime       = "dotnetcore2.1"

  filename      = "empty_lambda_folder.zip"

  timeout = 30
  memory_size = 256
  role = "${aws_iam_role.lambda_role.arn}"

  /*environment {
    variables = {
      SourceBucket_Name     = "${module.source_bucket.bucket_name}"
      SourceBucket_FileName = "${var.download_source_default_file_name}"
      Database_CounterTable = "${module.counter_table.table_name}"
    }*/
}
