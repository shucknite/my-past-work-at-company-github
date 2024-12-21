provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_cloudbuild_trigger" "build_trigger" {
  name        = "build-python-app"
  description = "Trigger to build and push Python app to Docker Hub"

  github {
    owner = var.github_owner
    name  = var.github_repo

    push {
      branch = "main"
    }
  }

#   build {
#     filename = "cloudbuild.yaml" 
#  }

# build {
#     steps {
#       name = "gcr.io/cloud-builders/docker"
#       args = ["build", "-t", "gcr.io/${google_project}/python-app:${GITHUB_SHA}", "."]
#     }
#   }
}
