#!/bin/sh
# ubuntu base box cleanup script for packer
# Robert Wang @github.com/robertluwang
# Jan 5th, 2018

export DEBIAN_FRONTEND=noninteractive

#  remove vbox guest source 
rm -rf /usr/src/vboxguest* 

# remove under tmp directory
rm -rf /tmp/*

# remove caches
find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;

apt-get -y purge linux-firmware
apt-get -y autoremove
apt-get -y clean

# defrag space 
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# clean history
cat /dev/null > ~/.bash_history
