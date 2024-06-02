resource "kubernetes_service_account" "k8s_service_account" {
  metadata {
    name      = "kubernetes-${var.service_account_name}"
    namespace = kubernetes_namespace.default.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.gsa.email
    }
  }
}

resource "google_service_account" "gsa" {
  account_id   = "ksa-${var.service_account_name}"
  display_name = "GKE Workload Identity Service Account"
}

resource "google_project_iam_binding" "workload_identity_user" {
  project = var.project_id  
  role    = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.service_account_name}]"
  ]
}

# Grant the roles/cloudsql.client role to the service account
resource "google_project_iam_binding" "cloudsql_client_role_binding" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  members = [
    "serviceAccount:${google_service_account.gsa.email}"
  ]
}

# Grant the roles/logging.logWriter role to the service account
resource "google_project_iam_binding" "logging_logwriter_role_binding" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  members = [
    "serviceAccount:${google_service_account.gsa.email}"
  ]
}