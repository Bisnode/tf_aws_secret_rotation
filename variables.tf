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

variable "lambda_iam_role_name" {
  type        = string
  description = "Name of IAM role to associate to lambda function"
}

variable "lambda_alarm_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
  default     = []
}

variable "lambda_enable_alarms" {
  type        = bool
  description = "Set to true to enable alarms on the lambda function"
  default     = false
}

variable "resource_tags" {
  type        = map(string)
  description = "Tags to add to resources created by this module (where applicable)"
  default     = {}
}
