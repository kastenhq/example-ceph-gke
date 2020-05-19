#!/bin/bash
# For easy debugging on console output
set -x

RELEASE=${1:-"debian-octopus"}
# Creating a directory based on timestamp... not unique enough
mkdir -p ~/ceph-deploy/install-$(date +%Y%m%d%H%M%S) && cd $_

#Install ceph key
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -a

#install ceph by pointing release repo to your Ubuntu sources list.
echo deb http://download.ceph.com/${RELEASE=}/ "$(lsb_release --codename --short)" main | sudo tee /etc/apt/sources.list.d/ceph.list
#Check & remove existing ceph setup
ceph-remove () {
ceph-deploy purge $HOST
ceph-deploy purgedata $HOST
ceph-deploy forgetkeys
}

#Ready to update & install ceph-deploy
sudo apt-get update && sudo apt-get install -y ceph-deploy

#Deploy ceph
HOST=$(hostname -s)
#ceph-remove
ceph-deploy new $HOST

#Add below lines into ceph.conf, pool size for number of replicas of data
#Chooseleaf is required to tell ceph we are only a single node and that it’s OK to store the same copy of data on the same physical node

cat >> ceph.conf <<EOF
osd pool default size=2
osd crush chooseleaf type = 0
EOF

#Time to install ceph
ceph-deploy install $HOST

#Create Monitor
ceph-deploy mon create-initial

sleep 1

#Create OSD & OSD with mounted drives /dev/sdb /dev/sdc /dev/sdd or /dev/disk/by-id/google-*
ceph-deploy osd create $HOST --data /dev/disk/by-id/google-osd-0 --data /dev/disk/by-id/google-osd-1 --data /dev/disk/by-id/google-osd-2 

#Redistribute config and keys
ceph-deploy admin $HOST

#Read permission to read keyring
sudo chmod +r /etc/ceph/ceph.client.admin.keyring

#Wait up to 45 seconds for ceph HEALTH_OK
sleep 45

#Here we go, check ceph health
ceph -s

ceph osd pool create kube 8 8
ceph auth add client.kube mon 'allow r' osd 'allow rwx pool=kube'
rbd pool init kube
ceph auth list

echo "Admin base64 key: $(ceph auth get-key client.admin | base64)"
echo "Kube base64 key: $(ceph auth get-key client.kube | base64)"
