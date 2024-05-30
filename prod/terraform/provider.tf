terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.30.0"
    }
  }
  backend "gcs" {
    prefix = "state/gke"
    bucket = "k8s-bucket-tfstate-rand"
  }
}

provider "google" {
  project     = "dtonic-demo-k8s"
  region      = "us-central1"
  # credentials = file("/Users/viks/Documents/dtonic-demo-k8s.json")
}

