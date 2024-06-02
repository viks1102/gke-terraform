# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "gke-cluster-nonprod" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  # Disable deletion protection
  deletion_protection = false
  # Optional, if you want multi-zonal cluster
  node_locations = [
    var.zone,  # Secondary zone
    # "us-central1-f"   # Another secondary zone
  ]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  
  node_config {
    disk_type = "pd-ssd"   # Specify SSD type
    disk_size_gb = 50      # Specify disk size to fit within your quota

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_write"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

}


########################
# resource "kubernetes_namespace" "default" {
#   metadata {
#     name = var.namespace
#   }
# }

# resource "kubernetes_service_account" "my_service_account" {
#   metadata {
#     name      = var.service_account_name
#     namespace = kubernetes_namespace.default.metadata[0].name
#     annotations = {
#       "iam.gke.io/gcp-service-account" = google_service_account.gsa.email
#     }
#   }
# }

# resource "google_service_account" "gsa" {
#   account_id   = var.service_account_name
#   display_name = "GKE Workload Identity Service Account"
# }

# resource "google_project_iam_binding" "workload_identity_user" {
#   role    = "roles/iam.workloadIdentityUser"
#   members = [
#     "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.service_account_name}]"
#   ]
# }