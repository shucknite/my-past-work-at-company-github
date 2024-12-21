terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.30.0"
    }
  }
}

provider "google" {
  project = "my-project-1-jill"
  region = "us-central1"
  zone = "us-central1-a"
  # credentials = file("gcp-key.json")
}

resource "google_storage_bucket" "tf-state-bucket" {
  name          = "tf-state-bucket-all"
  location      = "us-central1"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}