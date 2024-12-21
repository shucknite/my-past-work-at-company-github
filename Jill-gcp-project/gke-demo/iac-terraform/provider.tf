provider "google" {
  project = "my-project-1-jill"
  region = "us-central1"
  zone = "us-central1-a"
  credentials = file("gcp-key.json")
}