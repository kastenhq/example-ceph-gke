output "wan_ip" {
  value = "${google_compute_instance.ceph.network_interface.0.access_config.0.nat_ip}"
}

output "local_ip" {
  value = "${google_compute_instance.ceph.network_interface.0.network_ip}"
}
