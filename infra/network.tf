resource "google_compute_network" "aludrasil" {
  name                    = "aludrasil"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "aludrasil_ew1" {
  name          = "aludrasil-ew1"
  ip_cidr_range = "10.10.0.0/24"
  region        = "europe-west1"
  network       = google_compute_network.aludrasil.id
}

resource "google_compute_firewall" "ssh_via_iap" {
  name    = "allow-ssh-via-iap"
  network = google_compute_network.aludrasil.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "ping" {
  name    = "allow-icmp"
  network = google_compute_network.aludrasil.name

  // Allow ping on all
  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "steam" {
  name    = "allow-steam"
  network = google_compute_network.aludrasil.name

  // Game traffic
  allow {
    protocol = "udp"
    ports = [
      // Steamworks P2P Networking, Voice Chat
      "3478",
      "4379-4380",
      // Gameplay traffic
      "27015-27030"
    ]
  }
  allow {
    protocol = "tcp"
    ports    = ["27015-27030"]
  }

  target_tags = ["steam"]
}

resource "google_compute_firewall" "valheim" {
  name    = "allow-valheim"
  network = google_compute_network.aludrasil.name

  allow {
    protocol = "udp"
    ports    = ["2456-2458"]
  }

  target_tags = ["valheim"]
}

resource "google_compute_address" "aludrasil" {
  name = "aludrasil"
}
