# launch k8s cluster using vagrant box dreamcloud-ub17k8s

[dreamcloud/ub17k8s](https://app.vagrantup.com/dreamcloud/boxes/ub17k8s) is a docker/k8s ready box, here is demo to show how to launch a 2 nodes k8s cluster in few mins using vagrant.

## tool set
- vagant 2.0.1
- virtualbox 5.1.30
- cmder/msys64, I use [portabledevops](https://github.com/robertluwang/portabledevops) which seamless integrated with vagrant/virtualbox

## prepare Vagrantfile

```
$ mkdir ~/vagrant/k8stest
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/ub17k8s/Vagrantfile
```

assume the k8s cluster setting:

- ub17k8s-master 10.110.0.15
- ub17k8s-node   10.110.0.16
- vm memory: 1024
- pod network: calico  

you can change if you want except pod network in Vagrantfile.

## launch k8s cluster from vagrant box 
```
$ date;vagrant up;date
Sat, Dec 30, 2017 12:47:25 PM
Sat, Dec 30, 2017 12:52:21 PM

$ vagrant status
Current machine states:

ub17k8s-master            running (virtualbox)
ub17k8s-node              running (virtualbox)
```
k8s cluster launched in exactly 5 mins !

## test k8s cluster 
2 nodes cluster is ready now.

### cluster nodes
```
vagrant@ub17k8s-master:~$ kubectl get nodes
NAME             STATUS    ROLES     AGE       VERSION
ub17k8s-master   Ready     master    4m        v1.9.0
ub17k8s-node     Ready     <none>    2m        v1.9.0
```
### system pods
```
vagrant@ub17k8s-master:~$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                      READY     STATUS    RESTARTS   AGE
kube-system   calico-etcd-gdmll                         1/1       Running   0          6m
kube-system   calico-kube-controllers-d669cc78f-nw5zz   1/1       Running   0          6m
kube-system   calico-node-rqlrw                         2/2       Running   0          6m
kube-system   calico-node-vt7vb                         2/2       Running   0          4m
kube-system   etcd-ub17k8s-master                       1/1       Running   0          6m
kube-system   kube-apiserver-ub17k8s-master             1/1       Running   0          5m
kube-system   kube-controller-manager-ub17k8s-master    1/1       Running   0          6m
kube-system   kube-dns-6f4fd4bdf-vs8g7                  3/3       Running   0          6m
kube-system   kube-proxy-mtw59                          1/1       Running   0          6m
kube-system   kube-proxy-nrdxq                          1/1       Running   0          4m
kube-system   kube-scheduler-ub17k8s-master             1/1       Running   0          5m
```
