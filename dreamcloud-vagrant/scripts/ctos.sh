#!/bin/bash
#  centos7 openstack with packstack provision script for packer  
#  Robert Wang
#  Jan 22th, 2018

# step0 presetup
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

# step 1 sw repo
yum install -y centos-release-openstack-pike openstack-utils
yum-config-manager --enable openstack-pike
yum update -y

# step 2 install packstack
yum install -y openstack-packstack

# step3 run packstack
packstack --gen-answer-file=packstack_`date +"%Y-%m-%d"`.conf

sed -i '/CONFIG_DEFAULT_PASSWORD=/c CONFIG_DEFAULT_PASSWORD=demo' packstack_`date +"%Y-%m-%d"`.conf
sed -i '/CONFIG_KEYSTONE_ADMIN_PW=/c CONFIG_KEYSTONE_ADMIN_PW=demo' packstack_`date +"%Y-%m-%d"`.conf
sed -i '/CONFIG_KEYSTONE_DEMO_PW=/c CONFIG_KEYSTONE_DEMO_PW=demo' packstack_`date +"%Y-%m-%d"`.conf
sed -i '/CONFIG_SWIFT_INSTALL=/c CONFIG_SWIFT_INSTALL=n' packstack_`date +"%Y-%m-%d"`.conf
 
sed -i '/10.0.2.15/s/10.0.2.15/10.120.0.21/g' packstack_`date +"%Y-%m-%d"`.conf

packstack --answer-file packstack_`date +"%Y-%m-%d"`.conf
