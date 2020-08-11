output "lambda_secret_name" {
  value       = aws_secretsmanager_secret.lambda_secret.name
  description = "The name of the secret created by this module"
}

output "lambda_secret_arn" {
  value       = aws_secretsmanager_secret.lambda_secret.arn
  description = "The ARN of the secret created by this module"
}
