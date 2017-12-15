# minikube TLS without verification

## minikube/kubectl connection
This error happened on all different platform,   
```
$ kubectl get pods
Unable to connect to the server: dial tcp 192.168.99.102:8443: connectex: A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.
```

There are many reasons and tons of workaround around the forums but there isn't one solid and quick to solve the issue. 

Most of chance, the ssh/ping working and routing looks good, TLS validation failed for ip:8443.

When change the network environment, it may work without any change.

The most worse case is firewall ON, block the traffic and port between host and vm guest.

## how to disable TLS verification for minikube
The remedy idea is from [thegridman](https://github.com/thegridman) [minikube/issues/1099#](https://github.com/kubernetes/minikube/issues/1099#issuecomment-299277514):

- setup port forward from host 8443 to minikube vm 8443 in virtualbox
- create new context minikube-vpn without TLS verify

```
$ VBoxManage controlvm minikube natpf1 k8s-apiserver,tcp,127.0.0.1,8443,,8443
$ VBoxManage controlvm minikube natpf1 k8s-dashboard,tcp,127.0.0.1,30000,,30000
$ kubectl config set-cluster minikube-vpn --server=https://127.0.0.1:8443 --insecure-skip-tls-verify
Cluster "minikube-vpn" set.

$ kubectl config set-context minikube-vpn --cluster=minikube-vpn --user=minikube
Context "minikube-vpn" created.

$ kubectl config use-context minikube-vpn
Switched to context "minikube-vpn".
```
now kubectl can talk with minikube cluster as usual, 
```
$ kubectl get pods
No resources found.
```
kubectl will talk to 127.0.0.1:8443 instead of 192.168.99.102:8443 now, 
```
$ kubectl get pods --v 7
I1214 02:04:04.661382    7184 loader.go:357] Config loaded from file C:\oldhorse\portableapps\msys64\home\erobwan/.kube/config
I1214 02:04:04.823382    7184 round_trippers.go:414] GET https://127.0.0.1:8443/api

I1214 02:04:05.218882    7184 round_trippers.go:414] GET https://127.0.0.1:8443/api/v1/namespaces/default/pods
I1214 02:04:05.219382    7184 round_trippers.go:421] Request Headers:
I1214 02:04:05.223382    7184 round_trippers.go:424]     Accept: application/json
I1214 02:04:05.223882    7184 round_trippers.go:424]     User-Agent: kubectl.exe/v1.8.0 (windows/amd64) kubernetes/6e93783
I1214 02:04:05.226882    7184 round_trippers.go:439] Response Status: 200 OK in 3 milliseconds
No resources found.
```
If want to use local docker client talk with minikube, do port forward 127.0.0.1:2374 to vm 2376, and disable TLS verify as below,   
```
$ VBoxManage controlvm minikube natpf1 k8s-docker,tcp,127.0.0.1,2374,,2376
$ eval $(minikube docker-env) 
$ unset DOCKER_TLS_VERIFY
$ export DOCKER_HOST="tcp://127.0.0.1:2374"
$ alias docker='docker --tls' 
```
let's verify local docker client:
```
$ docker ps
CONTAINER ID        IMAGE                                                  COMMAND                  CREATED             STATUS              PORTS               NAMES                                              
ed0e8735c0a8        gcr.io/google_containers/k8s-dns-sidecar-amd64         "/sidecar --v=2 --..."   39 minutes ago      Up 40 minutes                           k8s_sidecar_kube-dns-86f6f55dd5-zfrfd_kube-system_9
f5dbbb0-e084-11e7-bcdb-080027c9ba66_7                                          
```                                                                            
## minikubefw.sh script

I make it as small script to simplify the setup, you can find [here](https://github.com/robertluwang/docker-hands-on-guide/blob/master/minikubefw.sh).

```
$ ./minikubefw.sh
Cluster "minikube-vpn" set.
Context "minikube-vpn" modified.
Switched to context "minikube-vpn".

$ kubectl get pods
No resources found.

$ docker ps
```



