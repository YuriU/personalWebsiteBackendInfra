resource "aws_dynamodb_table" "table" {
  name           = "${var.name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "${var.partitionKey}"

   attribute {
    name = "${var.partitionKey}"
    type = "${var.partitionKeyType}"
  }
}

resource "aws_iam_policy" "table_read_write_policy" {
  name        = "DynamoDB_${var.name}_ReadWriteAccessPolicy"
  path        = "/"
  description = "Policy to access dynamo db table"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "${aws_dynamodb_table.table.arn}"
    }
    ]
}
EOF
}