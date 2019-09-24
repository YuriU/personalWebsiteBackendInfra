resource "aws_s3_bucket" "artifacts_bucket" {
  bucket = "${var.application_name}-artifacts"
  
  force_destroy = true
}

resource "aws_iam_role" "code_build_role" {
  name = "${var.application_name}_code_build"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "policy" {
  role = "${aws_iam_role.code_build_role.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.artifacts_bucket.arn}",
        "${aws_s3_bucket.artifacts_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "lambda_build" {
  name          = "${var.application_name}_build"
  description   = "${var.application_name} build"
  build_timeout = "5"
  service_role  = "${aws_iam_role.code_build_role.arn}"

  artifacts {
    type = "S3"
    name = "artifacts"
    location = "${aws_s3_bucket.artifacts_bucket.bucket}"
    packaging = "ZIP"
    path = "build_output"
  }

  cache {
    type     = "S3"
    location = "${aws_s3_bucket.artifacts_bucket.bucket}"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }
  }

  source {
    type            = "GITHUB"
    location        = "${var.github_location}"
    git_clone_depth = 1
  }
}