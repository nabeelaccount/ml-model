#################################################################################################
# Archive application (zip) as required by Lambda function
#################################################################################################
data "archive_file" "lambda" {
  type = "zip"
  source_dir = "${path.module}/app/"
  output_path = "${path.module}/app/${var.endpoint_path}.zip"
}

resource "aws_lambda_function" "prediction_lambda" {
  filename = "${path.module}/app/${var.endpoint_path}.zip"
  function_name = var.name
  role = aws_iam_role.lambda_role.arn

  # app name + function name
  handler = main.lambda_handler

  # used to trigger udpdate
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"
}

