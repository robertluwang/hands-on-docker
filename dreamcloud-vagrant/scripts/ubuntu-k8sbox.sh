#!/bin/bash
#  ubuntu k8s box provision script for packer  
#  Robert Wang
#  Jan 4th, 2018

export DEBIAN_FRONTEND=noninteractive

# install docker
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker
systemctl start docker

usermod -aG docker vagrant

rm get-docker.sh


# install k8s 
apt-get update && apt-get install -y -q apt-transport-https
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get install -y -q kubelet kubeadm kubectl kubernetes-cni
