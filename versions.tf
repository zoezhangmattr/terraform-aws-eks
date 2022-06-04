terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.80"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=3.4"
    }
  }
}
