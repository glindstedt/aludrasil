provider "google" {
  project = "aludrasil"
  region  = "europe-west1"
}

locals {
  iap_tunnel_users = [
    "gustaflindstedt@gmail.com"
  ]
}
