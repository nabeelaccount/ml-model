resource "aws_s3_bucket" "mode_storage" {
  bucket = "nabeel-cicd-mi-model2"
}

# resource "aws_s3_bucket" "lambda_dependency_packages" {
#   bucket = "nabeel-lambda-dep-packages"
# }