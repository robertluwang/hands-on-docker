#!/bin/sh
# centos base box cleanup script for packer
# Robert Wang @github.com/robertluwang
# Jan 6th, 2018

#  remove vbox guest source 
rm -rf /usr/src/vboxguest* 

# remove under tmp directory
rm -rf /tmp/*

# remove caches
find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;

# defrag space 
dd if=/dev/zero of=/EMPTY bs=1M || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# clean history
cat /dev/null > ~/.bash_history && history -c
