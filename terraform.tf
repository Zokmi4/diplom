provider "google" {
  credentials = file("C:/diplom/tms-study-441511-ce8967187d24.json")
  project     = "tms-study-441511"
  region      = "us-central1"
  zone        = "us-central1-a"
}

resource "google_compute_health_check" "default" {
  name                = "instance-health-check"
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 3
  unhealthy_threshold = 3

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

resource "google_compute_instance" "dev" {
  name         = "dev-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
  EOF

  depends_on = [google_compute_health_check.default]
}

resource "google_compute_instance" "test" {
  name         = "test-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
  EOF

  depends_on = [google_compute_health_check.default]
}

resource "google_compute_instance" "prod" {
  name         = "prod-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
  EOF

  depends_on = [google_compute_health_check.default]
}

resource "google_storage_bucket" "shared_bucket" {
  name     = "bucket-diplom"
  location = "US"
}
