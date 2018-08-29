# Terrafrom Ceph cluster in GCE within 5 mins

This example is based on http://minhcd.com/setup-ceph-1-node-cluster-tren-gcp-voi-terraform/

## Requirements

1. Account in https://cloud.google.com/ and gcloud SA JSON file https://cloud.google.com/iam/docs/creating-managing-service-account-keys
2. Download and install `terraform`: https://www.terraform.io/downloads.html

## How to

1. cd into folder with `terraform` files and init it
```console
tarraform init
```

1.5. Create `terraform.tfvars` with your varibales
```yaml
region = "us-west1"
region_zone = "us-west1-a"
project_name = "gcloud_project_name"
credentials_file_path = "~/my_new_sa.json"
private_key_path = "~/.ssh/id_rsa.new.special.key"
disk_size = 30
cluster_name = "my-ceph-test-cluster"
```

2. Create a plan. It will ask you for vars without default values.
```console
tarraform plan
```

3. Apply your plan.
```console
tarraform apply
```
