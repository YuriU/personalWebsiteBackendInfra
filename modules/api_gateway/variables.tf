variable "application_name" {
  description = "Lambda name"
}

variable "path_part" {
  description = "Part of the path"
}

variable "lambda_invoke_arn" {
    description = "ARN to the lambda function"
  
}

variable "lambda_function_name" {
    description = "Name of lambda"
}

variable "binary_media_types" {
    description = "Media types treated as binary"
    type = "list"
}
