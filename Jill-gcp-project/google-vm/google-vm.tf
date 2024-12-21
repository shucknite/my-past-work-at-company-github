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
  credentials = file("gcp-key.json")
}

resource "google_compute_network" "default-network" {
  name = "network"
}
resource "google_compute_instance" "default-instance" {
  name         = "instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.default-network.name
  }

  # metadata = {
  #   ssh-keys = "username:${file("~/.ssh/id_rsa.pub")}"
  # }

   metadata = {
    ssh-keys = <<EOF
      ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCglrUEftN+Dy3ekFVja8As0DcuzS/CXPv+NYDyx1KaXnyFHvmm+PXMk7/KkTjRAf020+ieKESwQ+WCUNSexa6en2v65I4TrcWPzpiY7OhGwSbCJ8mtkA1P9+rbEVBWKqV8iPlY4d++zK3i0H+ggpt2eeTme+T2rvwOU+ZCZkV+NCi03UWCIGpUI/8hFNgU0z2d9EQpGFbhIWXT3iU8tZpKWWmrF/G52rwVG1Juga72RurOXYgcH1ihofOtsUBoxCXyNvwmojxdWkP8dkXJ/ZIVDX9L06pJolnZ0Yu2Rs3Vkd+TcsNitlkXM4tFeteN1A3hZ9VS+8wzeNPBMG+OOWhn shucknite\shucknite@shucknite   
    EOF
  }

  # metadata = {
  #   ssh-keys = <<EOF
  #     terakey:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqaF7TqtimTUtqLdZIspKjuTXXXXnkbW7N9TQBPXazu terakey
      
  #   EOF
  # }
 
}

# resource "google_compute_project_metadata" "my_ssh_key" {
#   metadata = {
#     ssh-keys = <<EOF
#       terakey:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqaF7TqtimTUtqLdZIspKjuTXXXXnkbW7N9TQBPXazu terakey
      
#     EOF
#   }
# }

resource "google_compute_instance_group" "default-instance-group" {
  name      = "instance-group"
}

resource "google_compute_instance_group_membership" "default-ig-membership" {
  instance        = google_compute_instance.default-instance.self_link
  instance_group  = google_compute_instance_group.default-instance-group.name
}

resource "google_compute_firewall" "default" {
  name    = "firewall-rule-name"
  network = google_compute_network.default-network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443","22"]
  }

  allow {
    protocol = "udp"
    ports    = ["53"]
  }

  source_ranges = ["0.0.0.0/0"]
}


