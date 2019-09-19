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
  count      = "${var.attached_policies_count}"
  policy_arn = "${var.attached_policies[count.index]}"
}

resource "aws_lambda_function" "function" {
  function_name = "${var.application_name}"
  handler       = "${var.entry_point}"
  runtime       = "dotnetcore2.1"

  filename      = "${var.lambda_bin_file_name}"

  timeout = 30
  memory_size = 256
  role = "${aws_iam_role.lambda_role.arn}"

  environment {
    variables = "${var.environment_variables}"
  }
}
