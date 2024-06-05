# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
# resource "google_compute_subnetwork" "private2" {
#   name                     = "private2"
#   ip_cidr_range            = "10.60.0.0/20"
#   region                   = "us-east1"
#   network                  = "k8s-vpc-global"
#   private_ip_google_access = true

#   secondary_ip_range {
#     range_name    = "k8s-pod-range"
#     ip_cidr_range = "10.28.0.0/14"
#   }
#   secondary_ip_range {
#     range_name    = "k8s-service-range"
#     ip_cidr_range = "10.27.0.0/20"
#   }
# }
