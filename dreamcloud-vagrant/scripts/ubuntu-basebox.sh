#!/bin/bash
#  ubuntu base box provision script for packer  
#  Robert Wang
#  Jan 6th, 2018

export DEBIAN_FRONTEND=noninteractive

# add user vagrant to sudo group vagrant 
if [ ! `cat /etc/group | grep vagrant`];then
    groupadd vagrant
fi

usermod -a -G vagrant vagrant

if [ -d /etc/sudoers.d/vagrant ];then
    rm /etc/sudoers.d/vagrant  
fi 

touch /etc/sudoers.d/vagrant

echo '%vagrant ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# update system
apt-get update -y -q && apt-get upgrade -y -q 
apt-get install -y -q python git dos2unix wget ifupdown 

