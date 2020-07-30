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
  name               = "${var.lambda_function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}

# Logging

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["${aws_cloudwatch_log_group.lambda_log_group.arn}:*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.lambda_log_group.arn}:*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.lambda_log_group.arn}:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.lambda_function_name}-logs"
  path        = "/"
  description = "IAM policy for logging from a Lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Secrets

resource "aws_iam_policy" "secret_access" {
  name        = "${var.lambda_function_name}-secrets"
  path        = "/"
  description = "IAM policy for accessing secrets from a Lambda"
  policy      = data.aws_iam_policy_document.secrets_access.json
}

data "aws_iam_policy_document" "secrets_access" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:UpdateSecretVersionStage"
    ]
    resources = concat(["${aws_secretsmanager_secret.lambda_secret.arn}*"], var.extra_secrets)
  }
}

resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.secret_access.arn
}

# Network

resource "aws_iam_policy" "network" {
  name        = "${var.lambda_function_name}-network"
  path        = "/"
  description = "IAM policy for accessing network from a Lambda"

  policy = data.aws_iam_policy_document.network.json
}

data "aws_iam_policy_document" "network" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "network" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.network.arn
}
