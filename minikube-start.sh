#!/usr/bin/bash
# minikube-start.sh
# start script for minikube + none driver on Linix VM
# Robert Wang  https://github.com/robertluwang
# Dec 12, 2017

export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
export KUBECONFIG=$HOME/.kube/config

sudo -E minikube start --vm-driver=none

sudo chown $USER:$USER /usr/local/bin/localkube
sudo chmod +x /usr/local/bin/localkube
