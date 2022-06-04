terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.8"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>3.4"
    }
  }
  required_version = "1.1.7"
}
