variable "project_id" {
  description = "The ID of the project in which to create the GKE cluster"
  type        = string
}

variable "region" {
  description = "The region in which to create the GKE cluster"
  type        = string
}

variable "zone" {
  description = "The zone in which to create the GKE cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "service_account_name" {
  description = "The name of the Kubernetes service account"
  type        = string
}

variable "namespace" {
  description = "The namespace for the Kubernetes service account"
  type        = string
}
