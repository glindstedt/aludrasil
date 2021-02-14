resource "google_service_account" "aludrasil" {
  account_id   = "aludrasil"
  display_name = "Aludrasil"
}

resource "google_compute_instance" "aludrasil" {
  name         = "aludrasil"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.aludrasil.name
    subnetwork = google_compute_subnetwork.aludrasil_ew1.name

    access_config {
      nat_ip = google_compute_address.aludrasil.address
    }
  }

  tags = ["steam", "valheim"]

  service_account {
    email  = google_service_account.aludrasil.email
    scopes = []
  }
}
