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

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = var.lambda_function_name
}

resource "aws_lambda_permission" "allow_secretsmanager" {
  statement_id  = "AllowExecutionFromSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.lambda_function_name}-logs"
  path        = "/"
  description = "IAM policy for logging from a Lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = var.lambda_iam_role_name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_policy" {
  role       = var.lambda_iam_role_name
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
  role       = var.lambda_iam_role_name
  policy_arn = aws_iam_policy.secret_access.arn
}

resource "aws_secretsmanager_secret" "lambda_secret" {
  name = var.secret_name
}

resource "aws_secretsmanager_secret_rotation" "lambda_secret_rotation" {
  secret_id           = aws_secretsmanager_secret.lambda_secret.id
  rotation_lambda_arn = var.lambda_function_arn

  rotation_rules {
    automatically_after_days = var.secret_rotation_interval
  }
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
  role       = var.lambda_iam_role_name
  policy_arn = aws_iam_policy.network.arn
}
