

# step0 presetup
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

# step 1 sw repo
yum install -y centos-release-openstack-pike
yum-config-manager --enable openstack-pike
yum update -y

# step 2 install packstack
yum install -y openstack-packstack

# step3 run packstack
packstack --gen-answer-file=packstack_`date +"%Y-%m-%d"`.conf
sed -i 's/10.0.2.15/10.120.0.21/g' packstack_`date +"%Y-%m-%d"`.conf
packstack --answer-file packstack_`date +"%Y-%m-%d"`.conf
