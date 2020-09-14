#!/bin/bash
BASE_PATH=$(cd `dirname ${0}`; pwd);
SSH_BAK="/root/openssh-bak"
SSH_ETC="/etc/ssh"
SSH_PAM="/etc/pam.d"
SSH_ROOT="/root/.ssh"

mkdir -p ~/openssh-bak
function bak_ssh_dir (){

	if [ -d $SSH_BAK ];then
		mkdir -p $SSH_BAK
	else
		echo $SSH_BAK 'exists.'
	fi
	if [ -d $SSH_ETC ];then
		cp -ar $SSH_ETC $SSH_BAK
	fi

	if [ -d $SSH_PAM ];then
		cp -ar $SSH_PAM $SSH_BAK
	fi

	if [ -d $SSH_ROOT ];then
		cp -ar $SSH_ROOT $SSH_BAK
	else
		mkdir $SSH_ROOT
		touch $SSH_ROOT/known_hosts
	fi
}

bak_ssh_dir

if [ $? == 0 ];then
yum localinstall ${BASE_PATH}/RPMS/x86_64/*.rpm -y

echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
#mkdir -p ~/.ssh/
#touch ~/.ssh/known_hosts
#echo "" > ~/.ssh/known_hosts
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
cp ${BASE_PATH}/ssh-copy-id /usr/bin/

chmod 600 /etc/ssh/*
systemctl restart sshd
else
    echo 'please check /root/openssh-bak'
fi

