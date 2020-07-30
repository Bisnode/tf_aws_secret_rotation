output "lambda_secret" {
  value       = aws_secretsmanager_secret.lambda_secret
  description = "The secret created by this module"
}
