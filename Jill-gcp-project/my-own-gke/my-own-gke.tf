# provider "google" {
#   project = "my-project-2-443401"
#   region  = "us-central1"
# }

# resource "google_container_cluster" "primary" {
#   name     = "my-gke-cluster"
#   location = "us-central1"

#   node_config {
#     machine_type = "e2-medium"
#   }

#   initial_node_count = 2
# }

# output "kubeconfig" {
#   value = google_container_cluster.primary.endpoint
# }

# resource "google_project_iam_custom_role" "gke_cluster_role" {
#   role_id     = "GKEClusterManager"
#   title       = "GKE Cluster Manager"
#   description = "Custom role for managing GKE clusters"
#   permissions = [
#     "container.clusters.create",
#     "container.clusters.delete",
#     "container.clusters.get",
#     "container.clusters.list",
#     "container.clusters.update",
#     "container.clusters.getCredentials",
#     "container.nodes.list",
#     "container.nodes.get",
#     "container.nodes.update",
#     "container.pods.list",
#     "container.pods.get",
#     "container.pods.update",
#     "container.clusterViewer",
  
#   ]
#   project = "my-project-2-443401"
# }

# resource "google_service_account" "gke_service_account" {
#   account_id   = "gke-service-account"
#   display_name = "GKE Service Account"
# }

# resource "google_project_iam_binding" "gke_cluster_role_binding" {
#   role    = google_project_iam_custom_role.gke_cluster_role.name
#   members = [
#     "serviceAccount:${google_service_account.gke_service_account.email}",
#   ]
#   project = "my-project-2-443401"
# }



# # https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/5.0.0/submodules/private-cluster

# # using google sdk cli gcloud container clusters create jill --zone us-west1-c --scopes storage-rw --machine-type n1-standard-2

# # installing gcloud components install kubectl to use kubectl in google kubernest cluster 

provider "google" {
  project = "my-project-2-443401"
  region  = "us-central1"
}

resource "google_container_cluster" "default" {
  name     = "my-gke-cluster"
  location = "us-central1"

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 100
  }

  initial_node_count = 2
}

resource "google_service_account" "default" {
  account_id   = "my-project-2-443401"
  display_name = "gke_service_account"
}

resource "google_project_iam_member" "gke_role" {
  project = "my-project-2-443401"
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "compute_role" {
  project = "my-project-2-443401"
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "iam_service_account_user" {
  project = "my-project-2-443401"
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.default.email}"
}


