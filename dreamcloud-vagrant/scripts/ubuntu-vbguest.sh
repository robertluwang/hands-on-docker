#!/bin/sh
# ubuntu base box virtualbox guest tool script for packer
# Robert Wang @github.com/robertluwang
# Jan 5th, 2018

export DEBIAN_FRONTEND=noninteractive

apt-get -y -q purge virtualbox*
apt-get install -y -q gcc build-essential

curl -sSLO http://download.virtualbox.org/virtualbox/5.2.4/VBoxGuestAdditions_5.2.4.iso
mount -o loop,ro VBoxGuestAdditions_5.2.4.iso /mnt

sh -E /mnt/VBoxLinuxAdditions.run /S
rm VBoxGuestAdditions_5.2.4.iso
umount /mnt

