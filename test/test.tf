locals {
  secret_name = "secret-rotation-test-secret-${random_id.random.dec}"
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/.terraform/lambda.zip"
}

data "aws_iam_policy_document" "lambda_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "secret-rotator-lambda-role-${random_id.random.dec}"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}

resource "aws_lambda_function" "secret_rotator_lambda" {
  filename      = data.archive_file.lambda_archive.output_path
  function_name = "secret_rotator_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "rotate.lambda_handler"
  timeout       = "300"

  source_code_hash = filebase64sha256(data.archive_file.lambda_archive.output_path)
  runtime          = "python3.8"
}


module "secret_rotator" {
  source = "./.."

  lambda_function_arn  = aws_lambda_function.secret_rotator_lambda.arn
  lambda_function_name = aws_lambda_function.secret_rotator_lambda.function_name
  lambda_iam_role_name = aws_iam_role.lambda_role.name
  secret_name          = local.secret_name
}

resource "random_id" "random" {
  byte_length = 8
}

provider "aws" {
  version = "~> 3.0"
}

provider "archive" {
  version = "~> 1.3"
}

provider "random" {
  version = "~> 2.3"
}
