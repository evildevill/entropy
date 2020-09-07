#!/bin/bash

printf '\033]2;install.sh\a'

G="\033[1;34m[*] \033[0m"
S="\033[1;32m[+] \033[0m"
E="\033[1;31m[-] \033[0m"

if [[ $(id -u) != 0 ]]
then
   echo -e ""$E"Permission denied!"
   exit
fi

{
ASESR="$(ping -c 1 -q www.google.com >&/dev/null; echo $?)"
} &> /dev/null
if [[ "$ASESR" != 0 ]]
then 
   echo -e ""$E"No Internet connection!"
   exit
fi

sleep 0.5
clear
sleep 0.5
cat banner/banner.txt
echo

sleep 1
echo -e ""$G"Installing dependencies..."
sleep 1

{
pkg update
pkg -y install git
pkg -y install python
apt-get update
apt-get -y install git
apt-get -y install python3
apt-get -y install python3-pip
apk update
apk add git
apk add python3
apk add py3-pip
pacman -Sy
pacman -S --noconfirm git
pacman -S --noconfirm python3
pacman -S --noconfirm python3-pip
zypper refresh
zypper install -y git
zypper install -y python3
zypper install -y python3-pip
yum -y install git
yum -y install python3
yum -y install python3-pip
dnf -y install git
dnf -y install python3
dnf -y install python3-pip
eopkg update-repo
eopkg -y install git
eopkg -y install python3
eopkg -y install pip
xbps-install -S
xbps-install -y git
xbps-install -y python3
xbps-install -y python3-pip
} &> /dev/null

if [[ -d ~/entropy ]]
then
sleep 0
else
cd ~
{
git clone https://github.com/evildevill/entropy.git
} &> /dev/null
fi

if [[ -d ~/entropy ]]
then
cd ~/entropy
else
echo -e ""$E"Installation failed!"
exit
fi

{
python3 -m pip install setuptools
python3 -m pip install -r requirements.txt
} &> /dev/null

{
cd bin
cp entropy /usr/local/bin
chmod +x /usr/local/bin/entropy
cp entropy /bin
chmod +x /bin/entropy
cp entropy /data/data/com.termux/files/usr/bin
chmod +x /data/data/com.termux/files/usr/bin/entropy
} &> /dev/null

sleep 1
echo -e ""$S"Successfully installed!"
sleep 1
