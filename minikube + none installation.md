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
oldhorse@ubuntu:~$ bash ./minikube-none.sh
Mon Dec 11 13:27:12 PST 2017

check minikube binary ...
minikube existing, change to minikube.old
kubectl existing, change to kubectl.old
localkube existing, change to localkube.old
Install minikube ...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 39.4M  100 39.4M    0     0  1224k      0  0:00:33  0:00:33 --:--:-- 1428k

Install kubectl ...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 49.9M  100 49.9M    0     0  1216k      0  0:00:42  0:00:42 --:--:-- 1488k

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

Mon Dec 11 13:31:15 PST 2017
minikube installation done
```
