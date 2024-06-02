output "kubernetes_service_account_name" {
  description = "The name of the Kubernetes service account"
  value       = kubernetes_service_account.k8s_service_account.metadata[0].name
}

output "google_service_account_email" {
  description = "The email of the Google Service Account"
  value       = google_service_account.gsa.email
}

# output "gke_cluster_name" {
#   description = "The name of the GKE cluster"
#   value       = google_container_cluster.primary.name
# }
