terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      version = "~> 4.60"
      source  = "hashicorp/aws"
    }
  }
}
