resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = var.lambda_function_name
}
