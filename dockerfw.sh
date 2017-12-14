#!/usr/bin/bash
# dockerfw.sh
# Robert Wang https://github.com/robertluwang
# remedy for local docker test without TLS verification when firewall ON 
# running platform:  win msys64/cygwin64
# usage: dockerfw.sh <docker machine name>
# Dec 14, 2017

export PORTSYS=`uname|cut -d'_' -f1`

check2375=`VBoxManage showvminfo "$1"|grep 127.0.0.1|grep 2375|cut -d, -f4|cut -d= -f2`
if [ $check2375 == '2375' ]; then 
    # if 127.0.0.1 2375 forward exist, skip
    echo 
else 
    VBoxManage controlvm "$1" natpf1 docker-fw,tcp,127.0.0.1,2375,,2376 
fi 

certwinpath=`docker-machine inspect "$1"|grep StorePath|tail -1|awk '{print $2}'|awk -F, '{print $1}'|awk -F\" '{print $2}'`
certcygpath=`cygpath -ml $certwinpath`
certdrive=`echo $certcygpath|awk -F:  '{print $1}'`
certpath=`echo $certcygpath|awk -F:  '{print $2}'`
if [ $PORTSYS = 'CYGWIN' ]; then
    dockercert='/cygdrive/'$certdrive$certpath
else
    dockercert='/'$certdrive$certpath
fi

export DOCKER_MACHINE_NAME="$1" 
export DOCKER_HOST="tcp://127.0.0.1:2375" 
export DOCKER_CERT_PATH=$dockercert
alias docker='docker --tls'  
