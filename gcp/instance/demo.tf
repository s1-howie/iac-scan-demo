provider "google" {
  project = "your-gcp-project-id"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_network" "demo_vpc" {
  name                    = "demo-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "demo_subnet" {
  name          = "demo-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.demo_vpc.self_link
}

resource "google_compute_firewall" "demo_firewall" {
  name    = "demo-firewall"
  network = google_compute_network.demo_vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["demo-instance"]
}

resource "google_compute_instance" "demo_instance" {
  name         = "demo-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.demo_subnet.self_link

    access_config {
      // Ephemeral IP
    }
  }

  tags = ["demo-instance"]

  metadata = {
    foo = "bar"
  }

  service_account {
    scopes = ["compute-ro", "storage-ro"]
  }
}
