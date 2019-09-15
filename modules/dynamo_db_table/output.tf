output "table_name" {
  value = "${aws_dynamodb_table.table.id}"
}

output "read_write_policy_arn" {
  value = "${aws_iam_policy.table_read_write_policy.arn}"
}