# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes" {
  account_id = "k8s-data-tonic-np"
}

resource "google_container_node_pool" "dev" {
  name    = "dev"
  cluster = google_container_cluster.gke-cluster-nonprod.id

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }

  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    labels = {
      team = "dev"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# resource "google_container_node_pool" "dev" {
#   name    = "dev"
#   cluster = google_container_cluster.gke-cluster-nonprod.id

#   management {
#     auto_repair  = true
#     auto_upgrade = true
#   }

#   autoscaling {
#     min_node_count = 0
#     max_node_count = 3
#   }

#   node_config {
#     preemptible  = false
#     machine_type = "e2-small"

#     labels = {
#       team = "devdev"
#     }

#     # taint {
#     #   key    = "instance_type"
#     #   value  = "dev"
#     #   effect = "NO_SCHEDULE"
#     # }

#     service_account = google_service_account.kubernetes.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }
