
[Vagrantfile](https://github.com/robertluwang/docker-hands-on-guide/blob/master/dreamcloud-vagrant/centos7k8sbox/Vagrantfile) and [set of script](https://github.com/robertluwang/docker-hands-on-guide/tree/master/dreamcloud-vagrant/scripts) used to build centos k8s vm or box from base box.

```
$ mkdir -p ~/vagrant/scripts
$ mkdir -p ~/vagrant/centos7k8s

$ cd ~/vagrant/scripts
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/scripts/centos-basebox.sh
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/scripts/centos-k8sbox.sh
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/scripts/centos-vbguest.sh
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/scripts/centos-publickey.sh
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/scripts/centos-cleanup.sh

$ cd ~/vagrant/centos7k8s
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/centos7box/Vagrantfile

$ vagrant up
```
