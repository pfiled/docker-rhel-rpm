#!/bin/bash

rpm -q epel-release > /dev/null
if [ $? -ne 0 ]
then
	echo "EPEL not installed, installing"

	cat <<EOM >/etc/yum.repos.d/epel-bootstrap.repo
[epel]
name=Bootstrap EPEL
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-\$releasever&arch=\$basearch
failovermethod=priority
enabled=0
gpgcheck=0
EOM

	yum --enablerepo=epel -y install epel-release
	rm -f /etc/yum.repos.d/epel-bootstrap.repo

	echo "EPEL is now installed"
fi

yum install -y spectool fedora-packager

usermod -a -G mock vagrant
