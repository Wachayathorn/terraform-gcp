terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("key.json")
  project     = "smarthome-chban"
  region      = "asia-southeast1"
  zone        = "asia-southeast1-b"
}

resource "google_compute_firewall" "allow-http" {
  name    = "cluster01-fw-allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "cluster01-fw-allow-https"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "cluster01-fw-allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}

resource "google_compute_firewall" "vpc-firewall" {
  name    = "cluster01-http-k8s-ports"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "6443", "30000-32767"]
  }
}

resource "google_compute_instance" "master" {
  name         = "master"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  metadata = {
    ssh-keys = "wachayathorn.singsena:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMdv/VzXE2iHq8vsjG9Kn38gMA3la7s+gy8koDBVse9E/Y2a0/MR8sbfpGNDjbOrKxatzX7w1R6wOBGS3VUsSnhUMtGaihcau39JytVBWw8SoXdx71GyGDvQcf/jw34Udy5Euzog2mj4aYxliHrtYiJ+u7IvMHuriVSndrKEkvagmlsYw1mu/RXT4mnaW+67s12Zn9wOdz6JcDJorVXwMp7Qi1M+QwDTTWXg5ia2JZmQ7XK4LStIHE4V0obyRC0mDBA/X6JKc8W5AcmhRtEhkhM8LYEG6zGBq/Z1WS0HCADA9Z14lTlW+/flJqxy7ryCH4ug72Jg9t71jmWaGtc/6DeHpi8GSG9e64fM4KbYNHGSR+ycgtJAv4Kz2aOR6JWL+CTOLmrxZbKkA70PrnRQuTM96PBPlraZgBVND2K7FzIyQlmei71j9U7GF+qmPADE1EB75JizXFhseLUOgfofabKtSzh70xqmHTHhUPUHNQz2SrbUofiWBaU5aLfhEixrc= wachayathorn.singsena@gmail.com"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "worker1" {
  name         = "worker1"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  metadata = {
    ssh-keys = "wachayathorn.singsena:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMdv/VzXE2iHq8vsjG9Kn38gMA3la7s+gy8koDBVse9E/Y2a0/MR8sbfpGNDjbOrKxatzX7w1R6wOBGS3VUsSnhUMtGaihcau39JytVBWw8SoXdx71GyGDvQcf/jw34Udy5Euzog2mj4aYxliHrtYiJ+u7IvMHuriVSndrKEkvagmlsYw1mu/RXT4mnaW+67s12Zn9wOdz6JcDJorVXwMp7Qi1M+QwDTTWXg5ia2JZmQ7XK4LStIHE4V0obyRC0mDBA/X6JKc8W5AcmhRtEhkhM8LYEG6zGBq/Z1WS0HCADA9Z14lTlW+/flJqxy7ryCH4ug72Jg9t71jmWaGtc/6DeHpi8GSG9e64fM4KbYNHGSR+ycgtJAv4Kz2aOR6JWL+CTOLmrxZbKkA70PrnRQuTM96PBPlraZgBVND2K7FzIyQlmei71j9U7GF+qmPADE1EB75JizXFhseLUOgfofabKtSzh70xqmHTHhUPUHNQz2SrbUofiWBaU5aLfhEixrc= wachayathorn.singsena@gmail.com"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "worker2" {
  name         = "worker2"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  metadata = {
    ssh-keys = "wachayathorn.singsena:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMdv/VzXE2iHq8vsjG9Kn38gMA3la7s+gy8koDBVse9E/Y2a0/MR8sbfpGNDjbOrKxatzX7w1R6wOBGS3VUsSnhUMtGaihcau39JytVBWw8SoXdx71GyGDvQcf/jw34Udy5Euzog2mj4aYxliHrtYiJ+u7IvMHuriVSndrKEkvagmlsYw1mu/RXT4mnaW+67s12Zn9wOdz6JcDJorVXwMp7Qi1M+QwDTTWXg5ia2JZmQ7XK4LStIHE4V0obyRC0mDBA/X6JKc8W5AcmhRtEhkhM8LYEG6zGBq/Z1WS0HCADA9Z14lTlW+/flJqxy7ryCH4ug72Jg9t71jmWaGtc/6DeHpi8GSG9e64fM4KbYNHGSR+ycgtJAv4Kz2aOR6JWL+CTOLmrxZbKkA70PrnRQuTM96PBPlraZgBVND2K7FzIyQlmei71j9U7GF+qmPADE1EB75JizXFhseLUOgfofabKtSzh70xqmHTHhUPUHNQz2SrbUofiWBaU5aLfhEixrc= wachayathorn.singsena@gmail.com"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}



