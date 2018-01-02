# launch k8s cluster using vagrant box dreamcloud-centos7k8s

[dreamcloud/centos7k8s](https://app.vagrantup.com/dreamcloud/boxes/centos7k8s) is a docker/k8s ready box, here is demo to show how to launch a 2 nodes k8s cluster in few mins using vagrant.

## tool set
- vagant 2.0.1
- virtualbox 5.1.30
- cmder/msys64, I use [portabledevops](https://github.com/robertluwang/portabledevops) which seamless integrated with vagrant/virtualbox

## prepare Vagrantfile

```
$ cd ~/vagrant/centos7k8stest
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/centos7k8s/Vagrantfile
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2987  100  2987    0     0   7744      0 --:--:-- --:--:-- --:--:-- 14291
```

assume the k8s cluster setting:

- centos7k8s-master 10.120.0.15
- centos7k8s-node   10.120.0.16
- vm memory: 1024
- pod network: calico  

you can change if you want except pod network in Vagrantfile.

## launch k8s cluster from vagrant box 
```
$ date;vagrant up;date
Mon, Jan 01, 2018  4:42:54 PM
Mon, Jan 01, 2018  4:45:37 PM

$ vagrant status
Current machine states:

centos7k8s-master            running (virtualbox)
centos7k8s-node              running (virtualbox)
```
k8s cluster launched in exactly 3 mins !

## test k8s cluster 
2 nodes cluster is ready now.

### cluster nodes
```
[vagrant@centos7k8s-master ~]$ kubectl get nodes
NAME                STATUS    ROLES     AGE       VERSION
centos7k8s-master   Ready     master    4m        v1.9.0
centos7k8s-node     Ready     <none>    1m        v1.9.0
```
### system pods
```
[vagrant@centos7k8s-master ~]$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                        READY     STATUS    RESTARTS   AGE
kube-system   calico-etcd-vhrj5                           1/1       Running   0          4m
kube-system   calico-kube-controllers-d669cc78f-rbpjs     1/1       Running   0          4m
kube-system   calico-node-9vx9j                           2/2       Running   0          4m
kube-system   calico-node-wbgh2                           2/2       Running   0          2m
kube-system   etcd-centos7k8s-master                      1/1       Running   0          3m
kube-system   kube-apiserver-centos7k8s-master            1/1       Running   0          3m
kube-system   kube-controller-manager-centos7k8s-master   1/1       Running   0          4m
kube-system   kube-dns-6f4fd4bdf-4rrbx                    0/3       Pending   0          4m
kube-system   kube-proxy-b5rhq                            1/1       Running   0          4m
kube-system   kube-proxy-bjjgp                            1/1       Running   0          2m
kube-system   kube-scheduler-centos7k8s-master            1/1       Running   0          4m
```
