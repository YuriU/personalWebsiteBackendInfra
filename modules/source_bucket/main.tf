resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}"
  
  force_destroy = true
}

resource "aws_iam_policy" "read_only_policy" {
  name        = "${var.name}_ReadOnlyAccessPolicy"
  path        = "/"
  description = "Policy to access source bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "${aws_s3_bucket.bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.bucket.arn}/*"
    }
  ]
}
EOF
}