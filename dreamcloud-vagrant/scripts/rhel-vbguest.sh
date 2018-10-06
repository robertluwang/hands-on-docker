#!/bin/bash
# rhel7.3 base box virtualbox guest tool script for packer
# Robert Wang @github.com/robertluwang
# Sept 22, 2018

mkdir /mnt

# packer will upload guest tool iso to home
mount -o loop,ro VBoxGuestAdditions.iso /mnt
yes | sh /mnt/VBoxLinuxAdditions.run || echo "VBoxLinuxAdditions.run exited $? and is suppressed."
rm VBoxGuestAdditions.iso
umount /mnt
