#!/bin/bash

git clone /docker-rhel-rpm
cd docker-rhel-rpm

# build docker rpm
spectool -g -C lxc-docker lxc-docker/lxc-docker.spec 
mock -r epel-6-x86_64 --buildsrpm --spec lxc-docker/lxc-docker.spec --sources lxc-docker --resultdir output
mock -r epel-6-x86_64 --rebuild --resultdir output output/lxc-docker-0.6.5-1.el6.src.rpm 

# build lxc rpm
spectool -g -C lxc lxc/lxc.spec
mock -r epel-6-x86_64 --buildsrpm --spec lxc/lxc.spec --sources lxc --resultdir output
mock -r epel-6-x86_64 --rebuild --resultdir output output/lxc-0.8.0-3.el6.src.rpm

# build kernel rpm
spectool -g -C kernel-ml-aufs kernel-ml-aufs/kernel-ml-aufs-3.10.spec
git clone git://git.code.sf.net/p/aufs/aufs3-standalone -b aufs3.10
pushd aufs3-standalone
git archive aufs3.10 > ../kernel-ml-aufs/aufs3-standalone.tar
popd
mock -r epel-6-x86_64 --buildsrpm --spec kernel-ml-aufs/kernel-ml-aufs-3.10.spec --sources kernel-ml-aufs --resultdir output
mock -r epel-6-x86_64 --rebuild --resultdir output output/kernel-ml-aufs-3.10.11-1.el6.src.rpm

cp output/*.rpm /docker-rhel-rpm/output
