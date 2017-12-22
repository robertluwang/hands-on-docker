# Installation script for minikube none driver on Linux VM

- [installation script](https://github.com/robertluwang/docker-hands-on-guide/blob/master/minikube-none.sh) for minikube + none driver on Linux VM
- idea from https://github.com/kubernetes/minikube, fixed few issues
- cleanup and build up minikube on Linux VM in few mins 

## docker installation 
The docker is pre-condition for localkube since k8s running as containers.

```
$ curl -fsSL get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh
```
## run installation script
```
$ curl -o minikube-none.sh https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/minikube-none.sh
$ dos2unix minikube-none.sh
$ bash ./minikube-none.sh
```

## running log
```
oldhorse@dreamcloud:~$ curl -o minikube-none.sh https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/minikube-none.sh
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1851  100  1851    0     0   3292      0 --:--:-- --:--:-- --:--:--  3293
oldhorse@dreamcloud:~$ dos2unix minikube-none.sh
dos2unix: converting file minikube-none.sh to Unix format ...
oldhorse@dreamcloud:~$ bash ./minikube-none.sh
Mon Dec 11 18:24:47 EST 2017

check minikube binary ...
kubectl existing, change to kubectl.old
[sudo] password for oldhorse:     
Install minikube ...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 39.4M  100 39.4M    0     0  5492k      0  0:00:07  0:00:07 --:--:-- 6133k

Install kubectl ...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 49.9M  100 49.9M    0     0  5657k      0  0:00:09  0:00:09 --:--:-- 6164k

setup MINIKUBE env ...

minikube start ...
Starting local Kubernetes v1.8.0 cluster...
Starting VM...
Getting VM IP address...
Moving files into cluster...
Downloading localkube binary
 148.25 MB / 148.25 MB [============================================] 100.00% 0s
 65 B / 65 B [======================================================] 100.00% 0s
Setting up certs...
Connecting to cluster...
Setting up kubeconfig...
Starting cluster components...
Kubectl is now configured to use the cluster.
===================
WARNING: IT IS RECOMMENDED NOT TO RUN THE NONE DRIVER ON PERSONAL WORKSTATIONS
	The 'none' driver will run an insecure kubernetes apiserver as root that may leave the host vulnerable to CSRF attacks

Loading cached images from config file.

Mon Dec 11 18:25:56 EST 2017
minikube installation done

oldhorse@dreamcloud:~$ minikube status
minikube: Running
cluster: Running
kubectl: Correctly Configured: pointing to minikube-vm at 127.0.0.1
oldhorse@dreamcloud:~$ kubectl get services
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   1m

ldhorse@dreamcloud:~$ docker ps
CONTAINER ID        IMAGE                                                  COMMAND                  CREATED              STATUS              PORTS               NAMES
7629769fcb9c        gcr.io/google_containers/k8s-dns-sidecar-amd64         "/sidecar --v=2 --lo…"   About a minute ago   Up About a minute                       k8s_sidecar_kube-dns-86f6f55dd5-ph7np_kube-system_adb62f87-deca-11e7-8301-080027005f20_0
a226200124e5        gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64   "/dnsmasq-nanny -v=2…"   About a minute ago   Up About a minute                       k8s_dnsmasq_kube-dns-86f6f55dd5-ph7np_kube-system_adb62f87-deca-11e7-8301-080027005f20_0
8e90e448aec4        gcr.io/google_containers/k8s-dns-kube-dns-amd64        "/kube-dns --domain=…"   About a minute ago   Up About a minute                       k8s_kubedns_kube-dns-86f6f55dd5-ph7np_kube-system_adb62f87-deca-11e7-8301-080027005f20_0
c4c25312465b        gcr.io/google_containers/kubernetes-dashboard-amd64    "/dashboard --insecu…"   About a minute ago   Up About a minute                       k8s_kubernetes-dashboard_kubernetes-dashboard-jzpqt_kube-system_ad18f829-deca-11e7-8301-080027005f20_0
309c2ecc30f2        gcr.io/google_containers/pause-amd64:3.0               "/pause"                 About a minute ago   Up About a minute                       k8s_POD_kube-dns-86f6f55dd5-ph7np_kube-system_adb62f87-deca-11e7-8301-080027005f20_0
41ca4fee72d9        gcr.io/google_containers/pause-amd64:3.0               "/pause"                 About a minute ago   Up About a minute                       k8s_POD_kubernetes-dashboard-jzpqt_kube-system_ad18f829-deca-11e7-8301-080027005f20_0
25352650cea2        gcr.io/k8s-minikube/storage-provisioner                "/storage-provisioner"   About a minute ago   Up About a minute                       k8s_storage-provisioner_storage-provisioner_kube-system_ac81b8fc-deca-11e7-8301-080027005f20_0
72e17446d426        gcr.io/google_containers/pause-amd64:3.0               "/pause"                 About a minute ago   Up About a minute                       k8s_POD_storage-provisioner_kube-system_ac81b8fc-deca-11e7-8301-080027005f20_0
011e321ad6c4        gcr.io/google-containers/kube-addon-manager            "/opt/kube-addons.sh"    About a minute ago   Up About a minute                       k8s_kube-addon-manager_kube-addon-manager-dreamcloud_kube-system_7b19c3ba446df5355649563d32723e4f_1
af8197dfc8cc        gcr.io/google_containers/pause-amd64:3.0               "/pause"                 About a minute ago   Up About a minute                       k8s_POD_kube-addon-manager-dreamcloud_kube-system_7b19c3ba446df5355649563d32723e4f_1

oldhorse@dreamcloud:~$ docker images
REPOSITORY                                             TAG                 IMAGE ID            CREATED             SIZE
gcr.io/google_containers/kubernetes-dashboard-amd64    v1.8.0              55dbc28356f2        2 weeks ago         119MB
gcr.io/k8s-minikube/storage-provisioner                v1.8.1              4689081edb10        4 weeks ago         80.8MB
gcr.io/google_containers/k8s-dns-sidecar-amd64         1.14.5              fed89e8b4248        2 months ago        41.8MB
gcr.io/google_containers/k8s-dns-kube-dns-amd64        1.14.5              512cd7425a73        2 months ago        49.4MB
gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64   1.14.5              459944ce8cc4        2 months ago        41.4MB
gcr.io/google-containers/kube-addon-manager            v6.4-beta.2         0a951668696f        6 months ago        79.2MB
gcr.io/google_containers/pause-amd64                   3.0                 99e59f495ffa        19 months ago       747kB
```
## sudo issue on EC2 Linux AMI 
May get this error when run sript, 
```
bash ./minikube-none.sh                  
sudo: minikube: command not found
```    
usually we put minikube/kubectl/localkube at /usr/local/bin, but /usr/local/bin is not in sudo secure_path.

so update secure_path in sudo config,
```
$ sudo visudo
Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
```

