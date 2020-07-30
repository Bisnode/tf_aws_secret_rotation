variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "secret_name" {
  type        = string
  description = "Name of secret"
}

variable "extra_secrets" {
  type        = list(string)
  description = "Optional list of ARNs for extra secrets the lambda should be able to access"
  default     = []
}

variable "lambda_function_arn" {
  type        = string
  description = "ARN of the lambda function to use for secret rotation"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the lambda function to use for secret rotation"
}

variable "lambda_function_layers" {
  type        = list(string)
  description = "List of ARNs to (optional) layers to include in lambda context"
  default     = []
}
