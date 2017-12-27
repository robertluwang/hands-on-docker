# k8s cluster script
It is a demo how to quickly setup a k8s cluster (2 nodes) for testing and education purpose.

```
pirvate network 10.100.0.0/24
10.100.0.15 k8s-master
10.100.0.16 k8s-node1
```

## tool set
- Vagrant v2.0.1 x64 on win7
- Virtulbox v5.1.30 x64 on win7
- portable msys64 on win7  [portabledevops](https://github.com/robertluwang/portabledevops)

## bring up k8s cluster with vagrant
```
$ cd ~/vagrant/k8s
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/k8s-cluster-vagrant/Vagrantfile
$ vagrant up
$ vagrant status
```
## k8s master setup 
```
$ vagrant ssh k8s-master
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/k8s-cluster-vagrant/k8s-master.sh 
$ chmod +x k8s-master.sh
$ bash ./k8s-master.sh 
or in debug
$ bash -x ./k8s-master.sh 
```
take note for token line from `kubeadm init`, will run on k8s-node1 later.
```
kubeadm join --token 8f2887.40b2166d13f9e298 10.100.0.15:6443 --discovery-token-ca-cert-hash sha256:4d7e234e8c9d3378c5ccf47f1a228eac5aad98e657af6538e2eecc261f022579 
```

## k8s node setup
```
$ vagrant ssh k8s-node1
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/k8s-cluster-vagrant/k8s-node.sh
$ chmod +x k8s-node.sh
$ bash ./k8s-node.sh 
or in debug
$ bash -x ./k8s-node.sh 
```
then manually run join command (from k8s-master) as root,
```
$ sudo kubeadm join --token 8f2887.40b2166d13f9e298 10.100.0.15:6443 --discovery-token-ca-cert-hash sha256:4d7e234e8c9d3378c5ccf47f1a228eac5aad98e657af6538e2eecc261f022579 
```


