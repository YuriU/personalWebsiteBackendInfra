resource "aws_api_gateway_rest_api" "gateway" {
  name        = "${var.application_name}"
  description = "Terraform Managed for ${var.application_name}"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  binary_media_types = "${var.binary_media_types}"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.gateway.root_resource_id}"
  path_part   = "${var.path_part}"
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
  uri                     = "${var.lambda_invoke_arn}"

  content_handling = "CONVERT_TO_TEXT"
}


resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_rest_api.gateway"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.gateway.id}"
  stage_name  = "default"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_name}"
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.gateway.execution_arn}/*/*/*"
}