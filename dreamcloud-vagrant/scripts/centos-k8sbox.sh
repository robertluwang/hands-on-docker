#!/bin/sh
# centos k8s box provision script for packer  
# Robert Wang  @github.com/robertluwang
# Jan 4th, 2018

# install docker
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker
systemctl start docker

rm get-docker.sh

usermod -aG docker vagrant

# compatability for cgroup driver
cat << EOF > /tmp/daemon.json
{
  "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
EOF
 
mv /tmp/daemon.json /etc/docker/

systemctl start docker

# install k8s 
cat  <<EOF  > /tmp/repo
[kubernetes] 
name=Kubernetes 
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 
enabled=1 
gpgcheck=1 
repo_gpgcheck=1 
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg 
EOF

mv /tmp/repo /etc/yum.repos.d/kubernetes.repo

# disable SELinux 
setenforce 0

yum install -y -q --nogpgcheck kubelet kubeadm kubectl

systemctl enable kubelet && sudo systemctl start kubelet

# iptable
cat <<EOF  > /tmp/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
 
mv /tmp/k8s.conf /etc/sysctl.d/
sysctl --system   

# kubelet cgroup-driver
sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
