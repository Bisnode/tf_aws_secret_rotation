variable "secret_name" {
  type        = string
  description = "Name of secret"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of lambda function to use for secret rotation"
}

variable "lambda_function_layers" {
  type        = list(string)
  description = "List of ARNs to (optional) layers to include in lambda context"
  default     = []
}
