# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes" {
  account_id = "k8s-data-tonic-prod"
}

resource "google_container_node_pool" "prod" {
  name    = "prod"
  cluster = google_container_cluster.gke-cluster-prod.id

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
      team = "prod"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
# Bind the Artifact Registry Reader role to the service account
resource "google_project_iam_member" "artifact_registry_reader" {
  project = "dtonic-demo-k8s"
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.kubernetes.email}"
}

# Bind the Storage Object Viewer role to the service account
resource "google_project_iam_member" "storage_object_viewer" {
  project = "dtonic-demo-k8s"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.kubernetes.email}"
}
