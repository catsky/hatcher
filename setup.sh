#!/bin/bash
#usage: wget -O - http://192.168.10.120:8080/setup.sh|bash

USERNAME=zookeeper

echo "This is *first script* you should run after os bare-metal installation."
echo "** It will properly configure the system and install zk-base."
echo ""
echo "** Make sure you have network connected. "
echo "   Otherwise would fail to install zk-base"
echo ""

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Updating system package database..."
apt-get -qq update > /dev/null

echo "install sudo..."
apt-get install -y -qq sudo git-core


echo "config sudo with NOPASSWD"
cp /etc/sudoers /etc/sudoers.bak
sed -ie "/^root.*/a $USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers

echo "now run as $USERNAME..."

echo "download zk-base..."
su - $USERNAME -c "git clone http://git.gea-interactive.com.au:1000/zoo-business-media/zk-base.git /home/$USERNAME/zk-base"

## the first try of connecting to the git repository would be likely fail.
## try again would fix this.
if [ $? -ne 0 ]; then
   echo "retry to download zk-base..."
   su - $USERNAME -c "git clone http://git.gea-interactive.com.au:1000/zoo-business-media/zk-base.git /home/$USERNAME/zk-base"
fi


echo "installing zk-base...(it may take quite a few minutes)"
su - $USERNAME -c "/home/$USERNAME/zk-base/install.sh"
