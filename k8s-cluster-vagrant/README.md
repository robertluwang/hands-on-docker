# k8s cluster with vagrant

## k8s vagrant box
- bring up multi vm nodes using vagrant [k8s dev box](https://kubernetes-v1-4.github.io/docs/getting-started-guides/vagrant/) 
- manually do mini config to setup k8s cluster

## create 2 vm in vagrant
I prepare this Vagrantfile for 2 nodes k8s cluster:

- k8s-master
- k8s-node1 
```
cd ~/vagrant/k8s                    
$ cat Vagrantfile                                        
Vagrant.configure("2") do |config|
    config.vm.box="gsengun/k8s-dev-box"
    
    config.vm.define "k8s-master" do |master|
        master.vm.hostname = "k8s-master"
        master.vm.network :private_network, ip: "10.100.0.15"
        master.vm.network "forwarded_port", guest: 8443, host: 8443, protocol: "tcp"
        master.vm.network "forwarded_port", guest: 30000, host: 30000, protocol: "tcp"
        master.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            vb.name="k8s-master"
            vb.memory=1024
        end
    end
    
    config.vm.define "k8s-node1" do |node1|
        node1.vm.hostname = "k8s-node1"
        node1.vm.network :private_network, ip: "10.100.0.16"
        node1.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            vb.name="k8s-node1"
            vb.memory=1024
        end
    end
end                                              
```
vm customization setting,
```
vb.memory 1G 
--natdnshostresolver1 on, will add host-only interface for private network for k8s cluster
master.vm.network :private_network, ip: "10.100.0.15"
node1.vm.network :private_network, ip: "10.100.0.16"
```
## update /etc/hosts for cluster ip
```
vagrant@k8s-master:~$ cat /etc/hosts
127.0.0.1       k8s-master      k8s-master

vagrant@k8s-node1:~$ cat /etc/hosts
127.0.0.1       k8s-node1       k8s-node1
```
changed to 
```
vagrant@k8s-master:~$ cat /etc/hosts
10.100.0.15       k8s-master      
10.100.0.16     k8s-node1
vagrant@k8s-node1:~$ cat /etc/hosts
10.100.0.15       k8s-master      
10.100.0.16     k8s-node1
```
can run these commands on each node,
```
sudo sed -i  '/k8s/d' /etc/hosts
sudo sed -i "1i10.100.0.15        k8s-master" /etc/hosts
sudo sed -i "2i10.100.0.16        k8s-node1" /etc/hosts
```
make sure you can ping each other.

## bring up 2 vm using vagrant 
```
$ vagrant up
Bringing machine 'k8s-master' up with 'virtualbox' provider...
Bringing machine 'k8s-node1' up with 'virtualbox' provider...
==> k8s-master: Importing base box 'gsengun/k8s-dev-box'...
==> k8s-master: Matching MAC address for NAT networking...
==> k8s-master: Checking if box 'gsengun/k8s-dev-box' is up to date...
==> k8s-master: Setting the name of the VM: k8s-master
==> k8s-master: Clearing any previously set network interfaces...
==> k8s-master: Preparing network interfaces based on configuration...
    k8s-master: Adapter 1: nat
    k8s-master: Adapter 2: hostonly
==> k8s-master: Forwarding ports...
    k8s-master: 22 (guest) => 2222 (host) (adapter 1)
==> k8s-master: Running 'pre-boot' VM customizations...
==> k8s-master: Booting VM...
==> k8s-master: Waiting for machine to boot. This may take a few minutes...
    k8s-master: SSH address: 127.0.0.1:2222
    k8s-master: SSH username: vagrant
    k8s-master: SSH auth method: private key
    k8s-master:
    k8s-master: Vagrant insecure key detected. Vagrant will automatically replace
    k8s-master: this with a newly generated keypair for better security.
    k8s-master:
    k8s-master: Inserting generated public key within guest...
    k8s-master: Removing insecure key from the guest if it's present...
    k8s-master: Key inserted! Disconnecting and reconnecting using new SSH key...
==> k8s-master: Machine booted and ready!
==> k8s-master: Checking for guest additions in VM...
==> k8s-master: Setting hostname...
==> k8s-master: Configuring and enabling network interfaces...
==> k8s-master: Mounting shared folders...
    k8s-master: /vagrant => C:/oldhorse/portableapps/msys64/home/erobwan/vagrant/k8s
==> k8s-node1: Importing base box 'gsengun/k8s-dev-box'...
==> k8s-node1: Matching MAC address for NAT networking...
==> k8s-node1: Checking if box 'gsengun/k8s-dev-box' is up to date...
==> k8s-node1: Setting the name of the VM: k8s-node1
==> k8s-node1: Fixed port collision for 22 => 2222. Now on port 2200.
==> k8s-node1: Clearing any previously set network interfaces...
==> k8s-node1: Preparing network interfaces based on configuration...
    k8s-node1: Adapter 1: nat
    k8s-node1: Adapter 2: hostonly
==> k8s-node1: Forwarding ports...
    k8s-node1: 22 (guest) => 2200 (host) (adapter 1)
==> k8s-node1: Running 'pre-boot' VM customizations...
==> k8s-node1: Booting VM...
==> k8s-node1: Waiting for machine to boot. This may take a few minutes...
    k8s-node1: SSH address: 127.0.0.1:2200
    k8s-node1: SSH username: vagrant
    k8s-node1: SSH auth method: private key
    k8s-node1:
    k8s-node1: Vagrant insecure key detected. Vagrant will automatically replace
    k8s-node1: this with a newly generated keypair for better security.
    k8s-node1:
    k8s-node1: Inserting generated public key within guest...
    k8s-node1: Removing insecure key from the guest if it's present...
    k8s-node1: Key inserted! Disconnecting and reconnecting using new SSH key...
==> k8s-node1: Machine booted and ready!
==> k8s-node1: Checking for guest additions in VM...
==> k8s-node1: Setting hostname...
==> k8s-node1: Configuring and enabling network interfaces...
==> k8s-node1: Mounting shared folders...
    k8s-node1: /vagrant => C:/oldhorse/portableapps/msys64/home/erobwan/vagrant/k8s
```
check status,
```
$ vagrant status
Current machine states:

k8s-master                running (virtualbox)
k8s-node1                 running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```
```
$ vagrant ssh k8s-master
Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-31-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
vagrant@k8s-master:~$
```
## k8s-master setup
### swap issue
need to disable swap on linux, otherwise kubectl won't work.

check swap 
```
vagrant@k8s-master:~$ swapon --summary
Filename                                Type            Size    Used    Priority
/dev/dm-1                               partition       524284  0       -1
```
turn it off by 
```
vagrant@k8s-master:~$ sudo swapoff -a
vagrant@k8s-master:~$ swapon --summary
```
turn off permanently in /etc/fstab, 
```
#/dev/mapper/vagrant--vg-swap_1 none            swap    sw              0       0
```
### api server ip 
for vagrant vm, the default interface is NAT 10.0.2.15, used for Internet access, that is why I add 2nd interface as host-only private 10.100.0.0/24.

However `kubeadm init` always pick up 10.0.2.15 as api server.
```
IPs [10.96.0.1 10.0.2.15]
```
2 interfaces,
```
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state 
    inet 10.0.2.15/24 brd 10.0.2.255 scope global enp0s3
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state 
    inet 10.100.0.15/24 brd 10.100.0.255 scope global enp0s8
```
we need to use --apiserver-advertise-address to specific the api server, in our case is 10.100.0.15.

### pod network 
check out network addon from <https://kubernetes.io/docs/concepts/cluster-administration/addons/>

we use the calico network addon, so need to add calico pod network to `kubeadm init`.

### mubeadm init to create cluster 
```
vagrant@k8s-master:~$ sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=10.100.0.15                                                                
[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.                                                                                        
[init] Using Kubernetes version: v1.8.6                                                    
[init] Using Authorization modes: [Node RBAC]                                             
[preflight] Running pre-flight checks                                                         
[preflight] WARNING: docker version is greater than the most recently validated version. Docker version: 17.09.0-ce. Max validated version: 17.03                                  
[preflight] Starting the kubelet service                                                     
[kubeadm] WARNING: starting in 1.8, tokens expire after 24 hours by default (if you require a non-expiring token use --token-ttl 0)                                                
[certificates] Generated ca certificate and key.                                           
[certificates] Generated apiserver certificate and key.                                       
[certificates] apiserver serving cert is signed for DNS names [k8s-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96
[certificates] Generated apiserver-kubelet-client certificate and key.                      
[certificates] Generated sa key and public key.                                             
[certificates] Generated front-proxy-ca certificate and key.                                
[certificates] Generated front-proxy-client certificate and key.                             
[certificates] Valid certificates and keys now exist in "/etc/kubernetes/pki"             
[kubeconfig] Wrote KubeConfig file to disk: "admin.conf"                                     
[kubeconfig] Wrote KubeConfig file to disk: "kubelet.conf"                                 
[kubeconfig] Wrote KubeConfig file to disk: "controller-manager.conf"                   
[kubeconfig] Wrote KubeConfig file to disk: "scheduler.conf"                                   
[controlplane] Wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"                                                           
[controlplane] Wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/manifests/kube-controller-manager.yaml"                                         
[controlplane] Wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/manifests/kube-scheduler.yaml"                                                           
[etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/manifests/etcd.yaml"                                                                                
[init] Waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests"                                                              
[init] This often takes around a minute; or longer if the control plane images have to be pulled.                                                                        
[apiclient] All control plane components are healthy after 172.501626 seconds                  
[uploadconfig] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace                                                                   
[markmaster] Will mark node k8s-master as master by adding a label and a taint             
[markmaster] Master k8s-master tainted and labelled with key/value: node-role.kubernetes.io/master=""                                                                
[bootstraptoken] Using token: 8f2887.40b2166d13f9e298                                      
[bootstraptoken] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials                                     
[bootstraptoken] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token                                                  
[bootstraptoken] Creating the "cluster-info" ConfigMap in the "kube-public" namespace                                                                         
[addons] Applied essential addon: kube-dns                                                   
[addons] Applied essential addon: kube-proxy                                            
Your Kubernetes master has initialized successfully!                                        
To start using your cluster, you need to run (as a regular user):                    
  mkdir -p $HOME/.kube                                                         
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config                                         
  sudo chown $(id -u):$(id -g) $HOME/.kube/config                                                                                                                                  
You should now deploy a pod network to the cluster.                                            
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:                     
  http://kubernetes.io/docs/admin/addons/                                                 
You can now join any number of machines by running the following on each node                 
as root:                                                                                   
  kubeadm join --token 8f2887.40b2166d13f9e298 10.100.0.15:6443 --discovery-token-ca-cert-hash sha256:4d7e234e8c9d3378c5ccf47f1a228eac5aad98e657af6538e2eecc261f022579             
```                                                                            
### run kubectl as normal user
```
mkdir -p $HOME/.kube                                                         
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config                              
```                                                                           
### install calico addon 
```
vagrant@k8s-master:~$ kubectl apply -f  https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml
configmap "calico-config" created
daemonset "calico-etcd" created
service "calico-etcd" created
daemonset "calico-node" created
deployment "calico-kube-controllers" created
clusterrolebinding "calico-cni-plugin" created
clusterrole "calico-cni-plugin" created
serviceaccount "calico-cni-plugin" created
clusterrolebinding "calico-kube-controllers" created
clusterrole "calico-kube-controllers" created
serviceaccount "calico-kube-controllers" created
```
### allow run k8s on master
this is 2 nodes test cluster, so allow run master,
```
vagrant@k8s-master:~$ kubectl taint nodes --all node-role.kubernetes.io/master-
node "k8s-master" untainted
```
will see master in node list,
```
vagrant@k8s-master:~$ kubectl get nodes -o wide
NAME         STATUS     ROLES     AGE       VERSION   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
k8s-master   NotReady   master    3m        v1.8.0    <none>        Ubuntu 16.04.1 LTS   4.4.0-31-generic   docker://Unknown
```
## k8s node setup 
### disable swap 
```
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```
### join node1 to cluster
```                                                                            
vagrant@k8s-node1:~$ sudo kubeadm join --token 8f2887.40b2166d13f9e298 10.100.0.15:6443 --discovery-token-ca-cert-hash sha256:4d7e234e8c9d3378c5ccf47f1a228eac5aad98e657af6538e2eecc261f022579 
[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.                                                                                                           
[preflight] Running pre-flight checks                                                                    
[preflight] WARNING: docker version is greater than the most recently validated version. Docker version: 17.09.0-ce. Max validated version: 17.03                                              
[discovery] Trying to connect to API Server "10.100.0.15:6443"                                             
[discovery] Created cluster-info discovery client, requesting info from "https://10.100.0.15:6443"                                                            
[discovery] Requesting info from "https://10.100.0.15:6443" again to validate TLS against the pinned public key 
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "10.100.0.15:6443"                                           
[discovery] Successfully established connection with API Server "10.100.0.15:6443"                             
[bootstrap] Detected server version: v1.8.6                                    
[bootstrap] The server supports the Certificates API (certificates.k8s.io/v1beta1)                                                                            
Node join complete:                                                                                 
* Certificate signing request sent to master and response
received.                                                                      
* Kubelet informed of new secure connection details.                              
Run 'kubectl get nodes' on the master to see this machine join.                
```   
## k8s cluster status 
```
vagrant@k8s-master:~$ kubectl get nodes
NAME         STATUS    ROLES     AGE       VERSION
k8s-master   Ready     master    26m       v1.8.0
k8s-node1    Ready     <none>    17m       v1.8.0
vagrant@k8s-master:~$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                       READY     STATUS    RESTARTS   AGE
kube-system   calico-etcd-p5gxr                          1/1       Running   0          18m
kube-system   calico-kube-controllers-78f554c7bb-zs97h   1/1       Running   0          18m
kube-system   calico-node-fwwfz                          2/2       Running   1          17m
kube-system   calico-node-lqbmm                          2/2       Running   0          18m
kube-system   etcd-k8s-master                            1/1       Running   0          17m
kube-system   kube-apiserver-k8s-master                  1/1       Running   0          17m
kube-system   kube-controller-manager-k8s-master         1/1       Running   0          17m
kube-system   kube-dns-684587645-h9d5n                   3/3       Running   0          5m
kube-system   kube-proxy-4qr52                           1/1       Running   0          24m
kube-system   kube-proxy-jx7xj                           1/1       Running   0          17m
kube-system   kube-scheduler-k8s-master                  1/1       Running   0          17m                                                                 
```
## calico network status
k8s-master
```
vagrant@k8s-master:~$ ip addr
5: tunl0@NONE: <NOARP,UP,LOWER_UP> mtu 1440 qdisc noqueue state UNKNOWN group default qlen 1
    link/ipip 0.0.0.0 brd 0.0.0.0
    inet 192.168.235.192/32 brd 192.168.235.192 scope global tunl0
       valid_lft forever preferred_lft forever
vagrant@k8s-master:~$ ip route
default via 10.0.2.2 dev enp0s3
10.0.2.0/24 dev enp0s3  proto kernel  scope link  src 10.0.2.15
10.100.0.0/24 dev enp0s8  proto kernel  scope link  src 10.100.0.15
172.17.0.0/16 dev docker0  proto kernel  scope link  src 172.17.0.1 linkdown
192.168.36.64/26 via 10.100.0.16 dev tunl0  proto bird onlink
blackhole 192.168.235.192/26  proto bird
```
k8s-node1
```
vagrant@k8s-node1:~$ ip addr
5: tunl0@NONE: <NOARP,UP,LOWER_UP> mtu 1440 qdisc noqueue state UNKNOWN group default qlen 1
    link/ipip 0.0.0.0 brd 0.0.0.0
    inet 192.168.36.64/32 brd 192.168.36.64 scope global tunl0
       valid_lft forever preferred_lft forever
vagrant@k8s-node1:~$ ip route
default via 10.0.2.2 dev enp0s3
10.0.2.0/24 dev enp0s3  proto kernel  scope link  src 10.0.2.15
10.100.0.0/24 dev enp0s8  proto kernel  scope link  src 10.100.0.16
172.17.0.0/16 dev docker0  proto kernel  scope link  src 172.17.0.1 linkdown
blackhole 192.168.36.64/26  proto bird
192.168.36.66 dev cali53e0955c3f0  scope link
192.168.235.192/26 via 10.100.0.15 dev tunl0  proto bird onlink
```

## k8s cluster test 
### prepare app file
create node.js app - refer https://kubernetes.io/docs/tutorials/stateless-application/hello-minikube/

server.js
```
var http = require('http');

var handleRequest = function(request, response) {
  console.log('Received request for URL: ' + request.url);
  response.writeHead(200);
  response.end('Hello World!');
};
var www = http.createServer(handleRequest);
www.listen(8080);
```
Dockerfile
```
FROM node:6.9.2
EXPOSE 8080
COPY server.js .
CMD node server.js
```
### build docker image
```
docker build -t hello-node:v1 .
vagrant@k8s-master:~$ docker build -t hello-node:v1 .
Sending build context to Docker daemon  1.966MB
Step 1/4 : FROM node:6.9.2
6.9.2: Pulling from library/node
75a822cd7888: Pull complete
57de64c72267: Pull complete
4306be1e8943: Pull complete
871436ab7225: Pull complete
0110c26a367a: Pull complete
1f04fe713f1b: Pull complete
ac7c0b5fb553: Pull complete
Digest: sha256:2e95be60faf429d6c97d928c762cb36f1940f4456ce4bd33fbdc34de94a5e043
Status: Downloaded newer image for node:6.9.2
 ---> faaadb4aaf9b
Step 2/4 : EXPOSE 8080
 ---> Running in 85a0b72d48e1
 ---> 9f54abc50746
Removing intermediate container 85a0b72d48e1
Step 3/4 : COPY server.js .
 ---> db8c27810362
Step 4/4 : CMD node server.js
 ---> Running in c7bca858ca91
 ---> 514fcf0edcaa
Removing intermediate container c7bca858ca91
Successfully built 514fcf0edcaa
Successfully tagged hello-node:v1
```
### deploy app hello-node
```
vagrant@k8s-master:~$ kubectl run hello-node --image=hello-node:v1 --port=8080
deployment "hello-node" created
vagrant@k8s-master:~$ kubectl get deployments
NAME         DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-node   1         1         1            1           9s
vagrant@k8s-master:~$ kubectl get pods
NAME                          READY     STATUS    RESTARTS   AGE
hello-node-69b47b745c-w7gzs   1/1       Running   0          19s
```
```
vagrant@k8s-master:~$ kubectl expose deployment hello-node --type=LoadBalancer
service "hello-node" exposed
vagrant@k8s-master:~$ kubectl get services
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.102.198.108   <pending>     8080:31061/TCP   10s
kubernetes   ClusterIP      10.96.0.1        <none>        443/TCP          1h
```
### run web app
```
vagrant@k8s-master:~$ curl 10.102.198.108:8080
Hello World!
```
## deploy kubernetes-bootcamp
```
$ kubectl run kubernetes-bootcamp --image=docker.io/jocatalin/kubernetes-bootcamp:v1 --port=8080
deployment "kubernetes-bootcamp" created

$ kubectl get pods
vagrant@k8s-master:~$ kubectl get pods
NAME                                   READY     STATUS    RESTARTS   AGE
hello-node-69b47b745c-w7gzs            1/1       Running   0          40m
kubernetes-bootcamp-6c74779b45-62pvk   1/1       Running   0          17s

vagrant@k8s-master:~$ kubectl get deployment
NAME                  DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-node            1         1         1            1           40m
kubernetes-bootcamp   1         1         1            1           34s
```
### kubectl proxy running in background
```
vagrant@k8s-master:~$ kubectl proxy &
vagrant@k8s-master:~$ Starting to serve on 127.0.0.1:8001

vagrant@k8s-master:~$ curl http://localhost:8001/version
{
  "major": "1",
  "minor": "8",
  "gitVersion": "v1.8.6",
  "gitCommit": "6260bb08c46c31eea6cb538b34a9ceb3e406689c",
  "gitTreeState": "clean",
  "buildDate": "2017-12-21T06:23:29Z",
  "goVersion": "go1.8.3",
  "compiler": "gc",
  "platform": "linux/amd64"
}

vagrant@k8s-master:~$ export POD_NAME=$(kubectl get pods -o go-template --template '{{range.items}}{{.metadata.name}}{{"\n"}}{{end}}')
vagrant@k8s-master:~$ echo Name of the Pod: $POD_NAME
Name of the Pod: kubernetes-bootcamp-6c74779b45-62pvk

vagrant@k8s-master:~$ curl http://localhost:8001/api/v1/proxy/namespaces/default/pods/$POD_NAME/
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-62pvk | v=1
```
### expose deployment 
```
vagrant@k8s-master:~$ kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
service "kubernetes-bootcamp" exposed
vagrant@k8s-master:~$ kubectl get services
NAME                  TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
hello-node            LoadBalancer   10.102.198.108   <pending>     8080:31061/TCP   50m
kubernetes            ClusterIP      10.96.0.1        <none>        443/TCP          2h
kubernetes-bootcamp   NodePort       10.111.121.106   <none>        8080:31742/TCP   10s

vagrant@k8s-master:~$ kubectl describe services/kubernetes-bootcamp
Name:                     kubernetes-bootcamp
Namespace:                default
Labels:                   run=kubernetes-bootcamp
Annotations:              <none>
Selector:                 run=kubernetes-bootcamp
Type:                     NodePort
IP:                       10.111.121.106
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  31742/TCP
Endpoints:                192.168.36.68:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

vagrant@k8s-master:~$ export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')

vagrant@k8s-master:~$ echo NODE_PORT=$NODE_PORT
NODE_PORT=31742

vagrant@k8s-master:~$ curl http://192.168.36.68:8080
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-62pvk | v=1
```
### scale to 4 pods
```
vagrant@k8s-master:~$ kubectl scale deployments/kubernetes-bootcamp --replicas=4
deployment "kubernetes-bootcamp" scaled
vagrant@k8s-master:~$ kubectl get pods -o wide
NAME                                   READY     STATUS    RESTARTS   AGE       IP                NODE
kubernetes-bootcamp-6c74779b45-62pvk   1/1       Running   0          18m       192.168.36.68     k8s-node1
kubernetes-bootcamp-6c74779b45-6ccts   1/1       Running   0          10s       192.168.235.195   k8s-master
kubernetes-bootcamp-6c74779b45-cqd4z   1/1       Running   0          10s       192.168.235.196   k8s-master
kubernetes-bootcamp-6c74779b45-xj98m   1/1       Running   0          10s       192.168.36.69     k8s-node1

vagrant@k8s-master:~$ curl http://10.100.0.15:$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-62pvk | v=1
vagrant@k8s-master:~$ curl http://10.100.0.15:$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-62pvk | v=1
vagrant@k8s-master:~$ curl http://10.100.0.15:$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-62pvk | v=1
vagrant@k8s-master:~$ curl http://10.100.0.15:$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-cqd4z | v=1
vagrant@k8s-master:~$ curl http://10.100.0.15:$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-62pvk | v=1
vagrant@k8s-master:~$ curl http://10.100.0.15:$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-xj98m | v=1
vagrant@k8s-master:~$ curl http://10.100.0.15:$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-6ccts | v=1
vagrant@k8s-master:~$ curl http://10.100.0.15:$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-6c74779b45-62pvk | v=1
```
we can see traffic going to different pod which dispatched by load balancer.

### scale down to 2 pods
```
vagrant@k8s-master:~$ kubectl scale deployments/kubernetes-bootcamp --replicas=2
deployment "kubernetes-bootcamp" scaled
vagrant@k8s-master:~$ kubectl get pods
NAME                                   READY     STATUS        RESTARTS   AGE
kubernetes-bootcamp-6c74779b45-62pvk   1/1       Running       0          21m
kubernetes-bootcamp-6c74779b45-6ccts   1/1       Running       0          2m
kubernetes-bootcamp-6c74779b45-cqd4z   1/1       Terminating   0          2m
kubernetes-bootcamp-6c74779b45-xj98m   1/1       Terminating   0          2m

vagrant@k8s-master:~$ kubectl get pods
NAME                                   READY     STATUS    RESTARTS   AGE
kubernetes-bootcamp-6c74779b45-62pvk   1/1       Running   0          44m
kubernetes-bootcamp-6c74779b45-6ccts   1/1       Running   0          26m
```

