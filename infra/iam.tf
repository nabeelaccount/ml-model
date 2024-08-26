#################################################################################################
# Enable Lambda to attach to this role
#################################################################################################
data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#################################################################################################
# Create Lambda Role
#################################################################################################
resource "aws_iam_role" "lambda_role" {
  name                = "ml_lambda_role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_trust_policy
}

#################################################################################################
# Provide the role with permissions
#################################################################################################
resource "aws_iam_policy" "lambda_permission_policy" {
  name        = "aws_iam_policy_for_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing lambda role"
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
      },
      {
        "Action": [
          "s3:GetObject"
        ],
        "Resource": "arn:aws:s3:::${aws_s3_bucket.mode_storage.bucket}/*",
        "Effect": "Allow"
      }
    ]
  }
  EOF
}


#################################################################################################
# Attach lambda permissions to role
#################################################################################################
resource "aws_iam_role_policy_attachment" "attach_lambda_policy_to_role" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_permission_policy.arn
}
