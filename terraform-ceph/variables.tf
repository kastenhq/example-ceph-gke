variable "region" {
  default = "us-west1"
}

variable "region_zone" {
  default = "us-west1-b"
}

variable "project_name" {
  description = "The ID of the Google Cloud project"
}

variable "credentials_file_path" {
  description = "Path to the JSON file used to describe your account credentials"
  default     = "~/.gcloud/service-account-Terraform.json"
}

variable "private_key_path" {
  description = "Path to file containing private key"
  default     = "~/.ssh/id_rsa"
}

variable "disk_size" {
  description = "OSD disk size"
  default = 10
}

variable "vm_type" {
  description = "GCP instance type"
  default = "g1-small"
}

variable "cluster_name" {
  description = "Ceph cluster/vm name"
  default = "ceph-test"
}

variable "ceph_release_name" {
  description = "Ceph release name. Check http://download.ceph.com/"
  default = "debian-luminous"
}
