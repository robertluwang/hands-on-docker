
[Vagrantfile](https://github.com/robertluwang/docker-hands-on-guide/blob/master/dreamcloud-vagrant/centos7box/Vagrantfile) and [set of script](https://github.com/robertluwang/docker-hands-on-guide/tree/master/dreamcloud-vagrant/scripts) used to build centos dev vm or box from base box.

```
$ mkdir -p ~/vagrant/scripts
$ mkdir -p ~/vagrant/centos7dev

$ cd ~/vagrant/scripts
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/scripts/centos-basebox.sh
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/scripts/centos-vbguest.sh
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/scripts/centos-publickey.sh
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/scripts/centos-cleanup.sh

$ cd ~/vagrant/centos7dev
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/centos7box/Vagrantfile

$ vagrant up
```


