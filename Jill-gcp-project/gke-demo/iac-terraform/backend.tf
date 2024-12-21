terraform {
 backend "gcs" {
   bucket  = "tf-state-bucket-all"
   prefix  = "terraform/state"
 }
}