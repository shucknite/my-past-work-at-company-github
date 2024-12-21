terraform {
 backend "gcs" {
   bucket  = "gcp-bucket-jill"
   prefix  = "terraform/state2"
 }
}