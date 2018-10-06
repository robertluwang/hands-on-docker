#!/bin/bash
#  rhel7.3  base  box  provision  script for packer  
#  Robert Wang
#  Sept 22th, 2018

# enable all NICs during boot
sed -i '/ONBOOT=no/ s/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-e*

# remove HWADDR and UUID from interface configuration
sed -E -i '/^(HWADDR|UUID)/d' /etc/sysconfig/network-scripts/ifcfg-e*

# add user vagrant to sudo group vagrant 
if [ ! `cat /etc/group | grep vagrant` ];then
    groupadd vagrant
fi

usermod -a -G vagrant vagrant

if [ -d /etc/sudoers.d/vagrant ];then
    rm /etc/sudoers.d/vagrant  
fi 

touch /etc/sudoers.d/vagrant

echo '%vagrant ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# SELinux to permissive mode
sed -i -e 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config





