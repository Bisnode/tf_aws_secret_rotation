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

  tags = var.resource_tags
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

# Alarms

resource "aws_cloudwatch_metric_alarm" "lambda_alarm" {
  count               = var.lambda_enable_alarms ? 1 : 0
  alarm_name          = "${var.lambda_function_name}-errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  evaluation_periods  = "1"
  threshold           = "1"
  datapoints_to_alarm = "1"
  alarm_description   = "An error running the ${var.lambda_function_name} lambda function occurred"
  alarm_actions       = var.lambda_alarm_actions
  treat_missing_data  = "notBreaching"
  dimensions = {
    FunctionName = var.lambda_function_name
  }
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
    resources = concat([aws_secretsmanager_secret.lambda_secret.arn], var.extra_secrets)
  }
}

resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = var.lambda_iam_role_name
  policy_arn = aws_iam_policy.secret_access.arn
}

resource "aws_secretsmanager_secret" "lambda_secret" {
  name = var.secret_name

  tags = var.resource_tags
}

resource "aws_secretsmanager_secret_rotation" "lambda_secret_rotation" {
  secret_id           = aws_secretsmanager_secret.lambda_secret.id
  rotation_lambda_arn = var.lambda_function_arn

  rotation_rules {
    automatically_after_days = var.secret_rotation_interval
  }

  tags = var.resource_tags
}
