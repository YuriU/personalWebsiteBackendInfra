output "base_url" {
  value = "${aws_api_gateway_deployment.api.invoke_url}"
}

output "api_gateway_id" {
  value = "${aws_api_gateway_rest_api.gateway.id}"
}

output "api_deployment_stage" {
  value = "${aws_api_gateway_deployment.api.stage_name}"
}
