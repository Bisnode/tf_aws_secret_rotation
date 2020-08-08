variable "secret_name" {
  type        = string
  description = "Name of secret to create and use for rotation"
}

variable "secret_rotation_interval" {
  type        = number
  description = "Number of days between automatic secret rotation"
  default     = 30
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

variable "lambda_iam_role_name" {
  type        = string
  description = "Name of IAM role to associate to lambda function"
}
