terraform {
  backend "gcs" {
    bucket          = "tfstate-bucket-4291-ideasextraordinarias-default"
    prefix          = "bastion/terraform.tfstate"

  }
}