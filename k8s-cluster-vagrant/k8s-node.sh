#!/usr/bin/bash 
# k8s-node.sh   k8s node setup script
# Ubuntu 16.04.1 LTS
# Robert Wang   https://github.com/robertluwang 
# Dec 27, 2017

# update k8s-node /etc/hosts
sudo sed -i  '/k8s/d' /etc/hosts
sudo sed -i "1i10.100.0.15        k8s-master" /etc/hosts
sudo sed -i "2i10.100.0.16        k8s-node1" /etc/hosts

# turn off swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
