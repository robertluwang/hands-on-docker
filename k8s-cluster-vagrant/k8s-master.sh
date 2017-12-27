#!/bin/bash 
# k8s-master.sh   k8s master setup script
# Ubuntu 16.04.1 LTS
# Robert Wang   https://github.com/robertluwang 
# Dec 27, 2017

# update k8s-master /etc/hosts
sudo sed -i  '/k8s/d' /etc/hosts
sudo sed -i "1i10.100.0.15        k8s-master" /etc/hosts
sudo sed -i "2i10.100.0.16        k8s-node1" /etc/hosts

# turn off swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

# create k8s cluster with calico network
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=10.100.0.15 

# allow normal user to run kubectl 
if [ -d $HOME/.kube ]; then
  rm -r $HOME/.kube
  mkdir -p $HOME/.kube 
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config                                         
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
fi

# install calico network addon
kubectl apply -f  https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml

# all run on master
kubectl taint nodes --all node-role.kubernetes.io/master-

