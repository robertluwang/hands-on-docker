#!/bin/bash
#  ubuntu openstack with devstack provision script for packer  
#  Robert Wang
#  Jan 22th, 2018

sudo apt install bridge-utils

git clone https://git.openstack.org/openstack-dev/devstack
cd devstack

# prepare local.conf
cat <<EOF > local.conf
[[local|localrc]] 
ADMIN_PASSWORD=secret
DATABASE_PASSWORD=\$ADMIN_PASSWORD
RABBIT_PASSWORD=\$ADMIN_PASSWORD
SERVICE_PASSWORD=\$ADMIN_PASSWORD
HOST_IP_IFACE=enp0s8
EOF

# run devstack
./stack.sh
