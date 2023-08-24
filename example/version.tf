terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.14"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>3.4"
    }
  }
  required_version = "1.4.2"
}
