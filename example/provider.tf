provider "aws" {
  default_tags {
    tags = {
      Provisioner = "Terraform"
    }
  }
}

provider "tls" {

}
