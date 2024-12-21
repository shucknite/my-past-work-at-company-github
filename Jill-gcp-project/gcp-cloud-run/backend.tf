terraform {
 backend "gcs" {
   bucket  = "tfstate-store-bucket2"
   prefix  = "terraform/state3"
 }
}