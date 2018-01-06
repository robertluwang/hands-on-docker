#!/bin/sh
#  ubuntu base box provision script for packer  
#  Robert Wang
#  Jan 4th, 2018

export DEBIAN_FRONTEND=noninteractive

# add user vagrant to sudo group vagrant 
groupadd vagrant
usermod -a -G vagrant vagrant

mv /etc/sudoers.d/vagrant  /etc/sudoers.d/vagrant.old
echo '%vagrant ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# update system
apt-get update -y -q && apt-get upgrade -y -q 
apt-get install -y -q python git dos2unix wget ifupdown 
