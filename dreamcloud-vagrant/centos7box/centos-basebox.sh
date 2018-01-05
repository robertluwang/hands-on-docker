#!/bin/bash
#  centos base box provision script for packer
#  Robert Wang @github.com/robertluwang
#  Jan 4th, 2018

# fix primary NAT interface issue
ifcfgname=`ls /etc/sysconfig/network-scripts|grep ifcfg|grep -v ifcfg-lo|sort|head -1`
sed -i '/ONBOOT=no/ s/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/$ifcfgname
sed -i '/UUID/d' /etc/sysconfig/network-scripts/$ifcfgname

# add user vagrant to sudo group vagrant 
groupadd vagrant
usermod -a -G vagrant vagrant

mv /etc/sudoers.d/vagrant  /etc/sudoers.d/vagrant.old
echo '%vagrant ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# disable SELinux 
setenforce 0

# update system
yum -y -q update && sudo yum -y -q upgrade 
yum install -y -q dos2unix

