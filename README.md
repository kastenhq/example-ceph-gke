# Easy way of testing Ceph with GKE and Ceph rbd provisioner.

This repo is for trying testing only. Please do not use in production :)

You can deploy a new all-in-one ceph cluster via terraform and then use it in your GKE cluster via given Helm chart.

Ceph provisioner repo: https://github.com/kubernetes-incubator/external-storage/tree/master/ceph/rbd

Following Helm will work only with UBUNTU based GKE cluster. 

The main issue with using RBD provisioner is to install rbd tool on all k8s nodes.
Provided helm chart is using daemonset to create a rbd executable, which uses `docker run` underneath

