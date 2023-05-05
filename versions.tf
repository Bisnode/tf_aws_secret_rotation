terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      version = "~> 4.66"
      source  = "hashicorp/aws"
    }
  }
}
