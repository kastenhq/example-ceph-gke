variable "osd_count" {
  default = "3"
}

resource "google_compute_disk" "osd" {
  count = "${var.osd_count}"
  name  = "osd-disk-${count.index}"
  type  = "pd-ssd"
  zone  = "${var.region_zone}"
  size  = "${var.disk_size}"
}

resource "google_compute_instance" "ceph" {
  name         = "${var.cluster_name}"
  machine_type = "${var.vm_type}"
  zone         = "${var.region_zone}"

  tags = ["ceph", "testing"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-xenial-v20170619a"
    }
  }

  attached_disk {
    source = "${google_compute_disk.osd.0.self_link}"
    // a unique device_name that will be reflected into the /dev/disk/by-id/google-* tree
    // of a Linux operating system running within the instance
    // I will use it for predictable/determined result. Thanks Google for this wise!
    device_name = "osd-0"
  }
  attached_disk {
    source = "${google_compute_disk.osd.1.self_link}"
    device_name = "osd-1"
  }
  attached_disk {
    source = "${google_compute_disk.osd.2.self_link}"
    device_name = "osd-2"
  }

  network_interface {
    network = "default"

    access_config {
      // Empty block will generate ephemeral IP for floatingIP.
      // If this block is omit, instance will not accessible from internet.
    }
  }

  scheduling {
    // Using it for reduced-price because i just lab.
    // DON'T USE IT ON PRODUCTION SYSTEM !!
    // preemptible = true
  }

  provisioner "file" {
    source = "scripts/ceph-one-node-install.sh"
    destination = "/tmp/ceph-one-node-install.sh"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file("${var.private_key_path}")}"
      timeout  = "5m"
      agent    = false
     }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ceph-one-node-install.sh",
      "/tmp/ceph-one-node-install.sh ${var.ceph_release_name}",
    ]

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file("${var.private_key_path}")}"
      timeout  = "5m"
      agent    = false
     }

  }

}
