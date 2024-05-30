# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "gke-cluster-prod" {
  name                     = "gke-cluster-prod"
  location                 = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = "k8s-vpc"
  subnetwork               = "private"
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  # Disable deletion protection
  deletion_protection = false
  # Optional, if you want multi-zonal cluster
  node_locations = [
    "us-central1-a"
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
    workload_pool = "dtonic-demo-k8s.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "10.48.0.0/14"
    services_secondary_range_name = "10.52.0.0/20"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }


}
