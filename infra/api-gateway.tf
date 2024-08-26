#################################################################################################
# Create the API Gateway
#################################################################################################
resource "aws_api_gateway_rest_api" "api_gateway" {
  name  = var.name
  description = "${var.name} API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


#################################################################################################
# Create API GATEWAY resources - adds specs
#################################################################################################
resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id = aws_api_gateway_rest_api.api_gateway.root_resource_id

  # path <gateway-rul>/endpoint
  path_part = var.endpoint_path
}


#################################################################################################
# Add API gateway POST Request Method
#################################################################################################
resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = "POST"
  authorization = "NONE"
}

#################################################################################################
# Integrating API Gateway with Lambda function
#################################################################################################
resource "aws_api_gateway_integration" "gateway_method" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = aws_api_gateway_method.api_gateway_method.http_method
  integration_http_method = "POST"

  # Informs lambda that the API requests is from AWS services
  type = "AWS_PROXY"
  uri = aws_lambda_function.prediction_lambda.invoke_arn
}


#################################################################################################
# Permissions for API GATEWAY to communicate with AWS Lambda
#################################################################################################
data "aws_caller_identity" "account_info" {}
data "aws_region" "current" {}

resource "aws_lambda_permission" "lambda_permissions" {
  statement_id = "AllowExecutionFromAPIGateway"
  action =  "lambda:InvokeFunction"
  function_name = aws_lambda_function.prediction_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${data.aws_region.current.id}:${data.aws_caller_identity.account_info.account_id}/*/${aws_api_gateway_method.api_gateway_method.http_method}/${var.endpoint_path}"
}

#################################################################################################
# Deploy the REST API GATEWAY
#################################################################################################
resource "aws_api_gateway_deployment" "deploy_api_gatway" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ 
    aws_api_gateway_integration.gateway_method,
    aws_api_gateway_method.api_gateway_method 
  ]
}

resource "aws_api_gateway_stage" "api_gateway_staging" {
  deployment_id = aws_api_gateway_deployment.deploy_api_gatway.id
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name = "development"
}