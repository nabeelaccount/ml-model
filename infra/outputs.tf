output "API_GATEWAY_INVOKE_URL" {
  value = "${aws_api_gateway_stage.api_gateway_staging.invoke_url}/${var.endpoint_path}"
}