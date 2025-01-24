provider "google" {
  credentials = file("C:/diplom/diplom-tms-448807-ed95ea7347b4.json")
  project     = "diplom-tms-448807"
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
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible
    echo "Ansible installed on dev-instance"
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
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible
    echo "Ansible installed on test-instance"
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
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible
    echo "Ansible installed on prod-instance"
  EOF

  depends_on = [google_compute_health_check.default]
}

resource "google_storage_bucket" "shared_bucket" {
  name     = "bucket-diplom"
  location = "US"
}

# Правило для разрешения доступа по SSH (порт 22)
resource "google_compute_firewall" "ssh-firewall" {
  name    = "ssh-firewall"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Правило для разрешения доступа к Jenkins (порт 8080)
resource "google_compute_firewall" "jenkins-firewall" {
  name    = "jenkins-firewall"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Output для dev-инстанса
output "dev_instance_name" {
  value = google_compute_instance.dev.name
}

output "dev_instance_ip" {
  value = google_compute_instance.dev.network_interface[0].access_config[0].nat_ip
}

# Output для test-инстанса
output "test_instance_name" {
  value = google_compute_instance.test.name
}

output "test_instance_ip" {
  value = google_compute_instance.test.network_interface[0].access_config[0].nat_ip
}

# Output для prod-инстанса
output "prod_instance_name" {
  value = google_compute_instance.prod.name
}

output "prod_instance_ip" {
  value = google_compute_instance.prod.network_interface[0].access_config[0].nat_ip
}