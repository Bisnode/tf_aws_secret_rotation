# tf_aws_secret_rotation

![build](https://github.com/Bisnode/tf_aws_secret_rotation/workflows/build/badge.svg)

Terraform module to configure an AWS Secrets Manager secret with custom lambda rotation.

The module configures both the secret and rotation scheme, including all necessary roles and permissions - the actual
lambda to use is provided as input to the module, allowing for maximum flexibility.

See the `test` directory for an example implementation.

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
| extra\_secrets | Optional list of ARNs for extra secrets the lambda should be able to access | `list(string)` | `[]` | no |
| lambda\_function\_arn | ARN of the lambda function to use for secret rotation | `string` | n/a | yes |
| lambda\_function\_name | Name of the lambda function to use for secret rotation | `string` | n/a | yes |
| lambda\_iam\_role\_name | Name of IAM role to associate to lambda function | `string` | n/a | yes |
| resource\_tags | Tags to add to resources created by this module (where applicable) | `map(string)` | `{}` | no |
| secret\_name | Name of secret to create and use for rotation | `string` | n/a | yes |
| secret\_rotation\_interval | Number of days between automatic secret rotation | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_secret\_arn | The ARN of the secret created by this module |
| lambda\_secret\_name | The name of the secret created by this module |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
