terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      version = "~> 4.59"
      source  = "hashicorp/aws"
    }
  }
}
