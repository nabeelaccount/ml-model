#################################################################################################
# Archive application (zip) as required by Lambda function
#################################################################################################
# data "archive_file" "lambda" {
#   type        = "zip"
#   source_dir  = "${path.module}/app/"
#   output_path = "${path.module}/app/${var.endpoint_path}.zip"
# }

resource "aws_lambda_function" "prediction_lambda" {
  # filename      = "${path.module}/app/main.zip"
  s3_bucket       = "nabeel-lambda-dep-packages"
  s3_key          = "main.zip"
  function_name = var.name
  role          = aws_iam_role.lambda_role.arn

  # app name + function name
  handler = "main.lambda_handler"

  # Trigger updates when the source code changes
  source_code_hash = filebase64sha256("${path.module}/app/main.zip")

  runtime = "python3.12"

  # Increase timeout to 30 seconds
  timeout = 30
}

