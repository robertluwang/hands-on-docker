#!/bin/sh

yum install -y -q dkms gcc make kernel-devel bzip2 binutils patch libgomp glibc-headers glibc-devel kernel-headers  kernel-devel-`uname -r` 

curl -LO http://download.virtualbox.org/virtualbox/5.2.4/VBoxGuestAdditions_5.2.4.iso
mount -o loop,ro VBoxGuestAdditions_5.2.4.iso /mnt
sh -E /mnt/VBoxLinuxAdditions.run
rm VBoxGuestAdditions_5.2.4.iso
umount /mnt
