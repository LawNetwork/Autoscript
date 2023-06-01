#!/bin/bash

dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`

#=============== LawNetwork ===============#

cp /root/Autoscript/menu/menu /usr/bin/menu
cp /root/Autoscript/menu/menu-ssh /usr/bin/menu-ssh
cp /root/Autoscript/menu/menu-set /usr/bin/menu-set
cp /root/Autoscript/menu/menu-ss /usr/bin/menu-ss
cp /root/Autoscript/menu/menu-vmess /usr/bin/menu-vmess
cp /root/Autoscript/menu/menu-vless /usr/bin/menu-vless
cp /root/Autoscript/menu/menu-trojan /usr/bin/menu-trojan
cp /root/Autoscript/menu/menu-theme /usr/bin/menu-theme
cp /root/Autoscript/menu/menu-backup /usr/bin/menu-backup
cp /root/Autoscript/menu/autoboot /usr/bin/autoboot
cp /root/Autoscript/menu/menu-tcp /usr/bin/menu-tcp
cp /root/Autoscript/menu/rebootvps /usr/bin/rebootvps
#cp /root/Autoscript/menu/menu-dns /usr/bin/menu-dns
cp /root/Autoscript/menu/info /usr/bin/info
cp /root/Autoscript/menu/mspeed /usr/bin/mspeed
cp /root/Autoscript/menu/mbandwidth /usr/bin/mbandwidth
cp /root/Autoscript/menu/restart /usr/bin/restart


#=============== LawNetwork ===============#

