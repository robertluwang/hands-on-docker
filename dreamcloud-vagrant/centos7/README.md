
# launch centos dev vm from dreancloud-centos7

I build [dreamcloud/centos7](https://app.vagrantup.com/dreamcloud/boxes/centos7) vagrant box as practise, it is a dev ready vm:

- Guest Tool, shared folder 
- gcc/git/python/pip

Here is demo how to launch centos vm from this base, add 2nd host-only interface for private network.

## Vagrantfile
```
Vagrant.configure("2") do |config|
    config.vm.box="dreamcloud/centos7"
    
    config.vm.define "centos7dev" do |ct7|
        ct7.vm.network :private_network, ip: "10.120.0.15"
        ct7.vm.hostname = "centos7dev"
        ct7.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            vb.name="centos7dev"
            vb.memory=1024
        end
    end
end
```
## vagrant up
```
$ vagrant up
Bringing machine 'centos7dev' up with 'virtualbox' provider...
==> centos7dev: Checking if box 'dreamcloud/centos7' is up to date...
==> centos7dev: Clearing any previously set forwarded ports...
==> centos7dev: Fixed port collision for 22 => 2222. Now on port 2200.
==> centos7dev: Clearing any previously set network interfaces...
==> centos7dev: Preparing network interfaces based on configuration...
    centos7dev: Adapter 1: nat
    centos7dev: Adapter 2: hostonly
==> centos7dev: Forwarding ports...
    centos7dev: 22 (guest) => 2200 (host) (adapter 1)
==> centos7dev: Running 'pre-boot' VM customizations...
==> centos7dev: Booting VM...
==> centos7dev: Waiting for machine to boot. This may take a few minutes...
    centos7dev: SSH address: 127.0.0.1:2200
    centos7dev: SSH username: vagrant
    centos7dev: SSH auth method: private key
==> centos7dev: Machine booted and ready!
[centos7dev] GuestAdditions 5.1.30 running --- OK.
==> centos7dev: Checking for guest additions in VM...
==> centos7dev: Setting hostname...
==> centos7dev: Configuring and enabling network interfaces...
    centos7dev: SSH address: 127.0.0.1:2200
    centos7dev: SSH username: vagrant
    centos7dev: SSH auth method: private key
==> centos7dev: Mounting shared folders...
    centos7dev: /vagrant => C:/oldhorse/portableapps/msys64/home/oldhorse/vagrant/centos7dev
```
## test vagrant box
shared folder mounted properly,
```
[vagrant@centos7dev ~]$ df -h|grep vagrant
vagrant                  440G  257G  184G  59% /vagrant
[vagrant@centos7dev ~]$ mount |grep vagrant
vagrant on /vagrant type vboxsf (rw,nodev,relatime)
```
NIC and Internet access,
```
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:41:33:65 brd ff:ff:ff:ff:ff:ff
    inet 10.120.0.15/24 brd 10.120.0.255 scope global enp0s8

[vagrant@centos7dev ~]$ ip route
default via 10.0.2.2 dev enp0s3 proto static metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100
10.120.0.0/24 dev enp0s8 proto kernel scope link src 10.120.0.15 metric 100

[vagrant@centos7dev ~]$ ping -c 2 google.ca
PING google.ca (172.217.12.67) 56(84) bytes of data.
64 bytes from dfw28s05-in-f3.1e100.net (172.217.12.67): icmp_seq=1 ttl=48 time=43.6 ms
64 bytes from dfw28s05-in-f3.1e100.net (172.217.12.67): icmp_seq=2 ttl=48 time=42.1 ms
```
