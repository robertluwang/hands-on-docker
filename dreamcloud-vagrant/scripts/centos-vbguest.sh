#!/bin/sh
# centos base box virtualbox guest tool script for packer
# Robert Wang @github.com/robertluwang
# Jan 6th, 2018

yum install -y -q gcc make kernel-devel bzip2 binutils patch libgomp glibc-headers glibc-devel kernel-headers  kernel-devel-`uname -r` 

# you can download guest tool iso 
#curl -sSLO http://download.virtualbox.org/virtualbox/5.2.4/VBoxGuestAdditions_5.2.4.iso
#mount -o loop,ro VBoxGuestAdditions_5.2.4.iso /mnt
# packer will upload guest tool iso to home
mount -o loop,ro VBoxGuestAdditions.iso /mnt
yes | sh /mnt/VBoxLinuxAdditions.run || echo "VBoxLinuxAdditions.run exited $? and is suppressed."
rm VBoxGuestAdditions.iso
umount /mnt




