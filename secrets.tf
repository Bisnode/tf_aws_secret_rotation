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
