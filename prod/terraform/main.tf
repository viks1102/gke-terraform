# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "gke-cluster-prod" {
  name                     = "gke-cluster-prod"
  location                 = "us-east1"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = "k8s-vpc-global"
  subnetwork               = google_compute_subnetwork.private2.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  # Disable deletion protection
  deletion_protection = false
  # Optional, if you want multi-zonal cluster
  node_locations = [
    # "us-central1-a",  # Secondary zone
    "us-east1-b"   # Another secondary zone
  ]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = true
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "dtonic-demo-k8s.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.1.0/28"
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
