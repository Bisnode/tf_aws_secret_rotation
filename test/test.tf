data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/test/lambda/"
  output_path = "${path.module}/test/.terraform/lambda.zip"
}

//resource "aws_lambda_function" "secret_rotator_lambda" {
//  filename      = "lambda_function_payload.zip"
//  function_name = "lambda_function_name"
//  role          = "" #module.secret_rotator aws_iam_role.iam_for_lambda.arn
//  handler       = "rotate.handler"
//
//  # The filebase64sha256() function is available in Terraform 0.11.12 and later
//  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
//  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
//  source_code_hash = filebase64sha256("lambda_function_payload.zip")
//
//  runtime = "nodejs12.x"
//
//  environment {
//    variables = {
//      foo = "bar"
//    }
//  }
//}
//
//
//module "secret_rotator" {
//  source = "./.."
//
//  #lambda_function_arn =
//}

provider "aws" {
  version = "~> 3.0"
}
