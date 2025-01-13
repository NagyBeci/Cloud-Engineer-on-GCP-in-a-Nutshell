resource "google_compute_instance" "tf_instance_1" {
  name         = "tf-instance-1"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20241210"
    }
  }

  network_interface {
    network    = "tf-vpc-757680"
    subnetwork = "subnet-01"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT

  allow_stopping_for_update = true
}

resource "google_compute_instance" "tf_instance_2" {
  name         = "tf-instance-2"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20241210"
    }
  }

  network_interface {
    network    = "tf-vpc-757680"
    subnetwork = "subnet-02"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT

  allow_stopping_for_update = true
}