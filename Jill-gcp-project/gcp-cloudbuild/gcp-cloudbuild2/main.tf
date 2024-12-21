# Variables for customization
variable "project_id" {
    default = "my-project-2-443401"
}
variable "region" {
  default = "us-central1"
}
variable "dockerhub_username" {
  default = "shucknite"
}
variable "dockerhub_password" {
  default = "Signal12@"
}

# Provider setup
provider "google" {
  project = var.project_id
  region  = var.region
}

# Service account for Cloud Build
resource "google_service_account" "cloud_build" {
  account_id   = "cloud-build-sa"
  display_name = "Cloud Build Service Account"
}

# Grant Cloud Build permissions
resource "google_project_iam_binding" "cloud_build_permissions" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"
  members = ["serviceAccount:${google_service_account.cloud_build.email}"]
}

# Create a secret for Docker Hub credentials
# resource "google_secret_manager_secret" "dockerhub_credentials" {
#   secret_id = "dockerhub-credentials"
#   replication {
#     automatic = true
#   }
# }

# Add Docker Hub credentials to Secret Manager
# resource "google_secret_manager_secret_version" "dockerhub_credentials_version" {
#   secret = google_secret_manager_secret.dockerhub_credentials.id
#   secret_data = jsonencode({
#     username = var.dockerhub_username
#     password = var.dockerhub_password
#   })
# }

# Cloud Build trigger configuration
resource "google_cloudbuild_trigger" "dockerhub_push" {
  name = "push-to-dockerhub"
  description = "Build and push Docker image to Docker Hub"
  github {
    owner = "shucknite"
    name  = "my-job-interview-projects-demo"
    push {
      branch = "my-job-interviews-projects-demo"
    }
  }


  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build", "-t", "docker.io/${var.dockerhub_username}/python-app:latest", "."
      ]
      dir = "Jill-gcp-project/gcp-cloudbuild/gcp-cloudbuild2" # Specify the working directory relative to the repo root
    }
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push", "docker.io/${var.dockerhub_username}/python-app:latest"
      ]
    }
    # secret {
    #   kms_key_name = "projects/${var.project_id}/locations/global/keyRings/<key-ring>/cryptoKeys/<key>"
    #   secret_env   = ["DOCKERHUB_CREDENTIALS"]
    # }
  }
}

# resource "google_cloudbuild_trigger" "dockerhub_push" {
#   project = "my-project-2-443401"
#   trigger_template {
#     branch_name = "my-job-interviews-projects-demo"
#     project_id  = "my-project-2-443401"
#     repo_name   = "shucknite"
#   }
#   build {
#     step {
#       name = "gcr.io/cloud-builders/docker"
#       args = ["build", "-t", "gcr.io/$PROJECT_ID/my-image", "."]
#       dir = "Jill-gcp-project/gcp-cloudbuild/gcp-cloudbuild2" # Specify the working directory relative to the repo root
#     }
#   }
# }


# TF_LOG=DEBUG terraform apply


