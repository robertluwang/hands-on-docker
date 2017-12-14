#!/usr/bin/bash
# minikubefw.sh
# Robert Wang https://github.com/robertluwang
# remedy for minikube without TLS verification when firewall ON
# running platform: win msys64/cygwin64
# Dec 14, 2017

check8443=`VBoxManage showvminfo minikube|grep 127.0.0.1|grep 8443|cut -d, -f4|cut -d= -f2`
if [ $check8443 == '8443' ]; then 
    # if 127.0.0.1 8443 forward exist, skip
    echo 
else 
    VBoxManage controlvm minikube natpf1 k8s-apiserver,tcp,127.0.0.1,8443,,8443
fi 

check30000=`VBoxManage showvminfo minikube|grep 127.0.0.1|grep 30000|cut -d, -f4|cut -d= -f2`
if [ $check30000 == '30000' ]; then 
    # if 127.0.0.1 30000 forward exist, skip
    echo 
else 
    VBoxManage controlvm minikube natpf1 k8s-dashboard,tcp,127.0.0.1,30000,,30000
fi 

kubectl config set-cluster minikube-vpn --server=https://127.0.0.1:8443 --insecure-skip-tls-verify
kubectl config set-context minikube-vpn --cluster=minikube-vpn --user=minikube
kubectl config use-context minikube-vpn  
