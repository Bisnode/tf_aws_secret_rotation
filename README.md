# tf_aws_secret_rotation

Terraform module to configure an AWS Secrets Manager secret with custom lambda rotation

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_account\_id | AWS account ID | `string` | n/a | yes |
| aws\_region | AWS region | `string` | n/a | yes |
| extra\_secrets | Optional list of ARNs for extra secrets the lambda should be able to access | `list(string)` | `[]` | no |
| lambda\_function\_arn | ARN of the lambda function to use for secret rotation | `string` | n/a | yes |
| lambda\_function\_layers | List of ARNs to (optional) layers to include in lambda context | `list(string)` | `[]` | no |
| lambda\_function\_name | Name of the lambda function to use for secret rotation | `string` | n/a | yes |
| secret\_name | Name of secret | `string` | n/a | yes |
| secret\_rotation\_interval | Number of days between automatic secret rotation | `number` | `30` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
