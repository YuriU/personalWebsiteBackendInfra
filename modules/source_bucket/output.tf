output "read_only_policy_arn" {
  value = "${aws_iam_policy.read_only_policy.arn}"
}

output "bucket_name" {
  value = "${aws_s3_bucket.bucket.bucket}"
}
