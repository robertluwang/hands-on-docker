# launch ubuntu dev vm from vagrant box

I build [dreancloud/ubuntu17.10](https://app.vagrantup.com/dreamcloud/boxes/ubuntu17.10) vagrant box as practise, it is a dev ready vm:

- Guest Tool, shared folder 
- ifupdown which removed from ubuntu 17.10 standard release
- gcc/python/pip

Here is demo how to launch ubuntu vm from this base, add 2nd host-only interface for private network.

## prepare Vagrantfile
```
$ mkdir ~/vagrant/ub17test
$ cd ~/vagrant/ub17test
$ curl -LO https://raw.githubusercontent.com/robertluwang/docker-hands-on-guide/master/dreamcloud-vagrant/ubuntu17.10/Vagrantfile
$ vagrant up

```
## vagrant with ubuntu 17.10 NIC
The reason to install ifupdown in dreancloud/ubuntu17.10 box, the current vagrant not supports ubuntu 17.10 NIC yet.

This is common error will hit, 
```
==> ub17test: Configuring and enabling network interfaces...
The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!

bash: line 3: /sbin/ifdown: No such file or directory
bash: line 19: /sbin/ifup: No such file or directory
```

The background story is since ubuntu 17.10, it uses netplan to handle network interface instead of /etc/network/interfaces.

It will use /etc/netplan/01-netcfg.yaml to configure systemd-networkd.

It shows NAT enp0s3 only if without ifupdown existing. 
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: yes
```
so you add 2nd host-only NIC in this yaml file,
```
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: yes
    enp0s8:
      dhcp4: no
      dhcp6: no
      addresses: [10.110.0.15/24]
```
to apply config yaml change, 
```
$ sudo netplan --debug generate
$ sudo netplan apply
```
I left [comments](https://github.com/hashicorp/vagrant/issues/9304) on github vagrant , hope it will be fixed in new release.

However there is another remedy, just install ifupdown to let vagrant to setup 2nd NIC enp0s8 using traditional way, and NAT handled by ubuntu as netplan. This is I have done inside dreamcloud/ubuntu17.10 box, so there is not extra work when add 2nd NIC in Vagrantfile.

## vagrant up hanging 
For vagrant 2.0.1, it hanging at with powershell version, 
```
$ vagrant up

ERROR vagrant: #<Vagrant::Errors::PowerShellInvalidVersion: The version of powershell currently installed on this host is less than
the required minimum version. Please upgrade the installed version of
powershell to the minimum required version and run the command again.

  Installed version: N/A
  Minimum required version: 3>
```

checked my powershell version is 2,
```
$PSVersionTable.PSVersion

Major  Minor  Build  Revision
-----  -----  -----  --------
2      0      -1     -1
```
Download WMF 4.0 from [here](https://www.microsoft.com/en-us/download/details.aspx?id=40855). Choice below package for Windows 7 SP1,
```
x64: Windows6.1-KB2819745-x64-MultiPkg.msu
```
reboot laptop it took long time to finish upgrade, finally the powershell upgraded to 4.0 
```
λ  $PSVersionTable

Name                           Value
----                           -----
PSVersion                      4.0
WSManStackVersion              3.0
SerializationVersion           1.1.0.1
CLRVersion                     4.0.30319.42000
BuildVersion                   6.3.9600.16406
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0}
PSRemotingProtocolVersion      2.2
```
vagrant up works prefect after powershell 4.0 upgrade.
