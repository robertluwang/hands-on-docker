# Docker TLS without verification

## TLS connection
This TLS connection error is most famous and painful issue when change the work environment, 
```
$ docker-machine env msys
Error checking TLS connection: Error checking and/or regenerating the certs: There was an error validating certificates for host "192.168.99.100:2376": dial tcp 192.168.99.100:2376: i/o timeout
You can attempt to regenerate them using 'docker-machine regenerate-certs [name]'.
Be advised that this will trigger a Docker daemon restart which might stop running containers.
```

There are many reasons and tons of workaround around the forums but there isn't one solid and quick to solve the issue. It happened on all docker release.

Most of chance, the ssh/ping working and routing looks good, TLS validation failed for ip:2376.

When change the network environment, it may work without any change.

The most worse case is firewall ON, block the traffic and port between host and vm guest.

Beside the firewall, the docker machine network is not stable, there is way to go to improve the coding quality.

## how to disable TLS verification for Docker
The idea is to add port forward in virtualbox from host:2375 to guest 2376, 
```
VBoxManage controlvm msys natpf1 docker-fw,tcp,127.0.0.1,2375,,2376
export DOCKER_MACHINE_NAME="msys"
export DOCKER_HOST="tcp://127.0.0.1:2375"
export DOCKER_CERT_PATH="/home/username/.docker/machine/machines/msys"
```
then docker --tls will check cert but skip the verification, 
```
$ docker --tls ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

## dockerfw.sh script
This [small script](https://github.com/robertluwang/docker-hands-on-guide/blob/master/dockerfw.sh) just make your life easy, to simplify the setup in seconds.

It provide same setting as below but without TLS verification, 
```
$ eval $(docker-machine env msys)
```
Here is demo, 
```
$ dockerfw.sh msys
$ docker run hello-world
Hello from Docker!
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                      PORTS               NAMES
75166628d602        hello-world         "/hello"            About a minute ago   Exited (0) 34 seconds ago                       determined_mayer
```

