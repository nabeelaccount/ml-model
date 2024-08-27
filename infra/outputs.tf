output "API_GATEWAY_INVOKE_URL" {
  value = "${aws_api_gateway_stage.api_gateway_staging.invoke_url}/${var.endpoint_path}"
}

output "CHECK" {
  value = "arn:aws:execute-api:${data.aws_region.current.id}:${data.aws_caller_identity.account_info.account_id}:${aws_api_gateway_rest_api.api_gateway.id}/${var.stage_name}/${aws_api_gateway_method.api_gateway_method.http_method}/${var.endpoint_path}"
}