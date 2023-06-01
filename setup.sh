#!/bin/bash

dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji='date +"%Y-%m-%d" -d "$dateFromServer"'

mkdir /etc/Lawnetwork

IP=$(wget -qO- ipinfo.io/ip)
echo "$IP" > /root/ipvps

# Text Coloring
clear
red='\e[1;31m'
green='\e[0;32m'
yellow='\e[1;33m'
blue='\e[1;36m'
none='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m";}
blue() { echo -e "\\033[36;1m${*}\\033[0m";}
yellow() { echo -e "\\033[33;1m${*}\\033[0m";}
green() { echo -e "\\033[32;1m${*}\\033[0m";}
red() { echo -e "\\033[31;1m${*}\\033[0m";}

# Or you can use colors from color.sh
source /root/Autoscript/addons/color.sh

############################################## LawNET ##############################################

# Checking Virtualization
cd
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as a root!"
    exit 1
fi
if [ "$(system-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported!"
    exit 1;
fi

############################################## LawNET ##############################################

# Setting up
clear
localip=$(hostname -I | cut -d\ -f1)
host=('hostname')
dart=$(cat /etc/hosts | grep -w 'hostname'  | awk '{print $2}')
if [[ "$host" != "$dart" ]]; then
    echo "$localip $(hostname)" >> /etc/hosts
fi

mkdir -p /etc/xray
clear

secs_to_human(){
    echo "Installation time: $((${1}/3600)) hours $((${1}/60)%60)) minutes $((${1}%60))"
}

starts=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6 = 1 > /dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6 = 1 > /dev/null 2>&1

coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
    if [ -f ~/bashrc ]; then
        . ~/bashrc
    fi
fi

mesg n || true
clear
vnstat -d
vnstat -m
END

chmod 644 /root/.profile

# Preparing all set up
chmod -R +x /root/Autoscript
cp /root/Autoscript/addons/color.sh /root/Autoscript/color.sh
cd /root/Autoscript/addons; ./Animation.sh

cd
mkdir -p /etc/Lawnet
mkdir -p /etc/Lawnet/theme
mkdir -p /var/lib/Lawnet-pro >/dev/null 2>&1
echo "IP=" >> /var/lib/Lawnet-pro/ipvps.conf
mkdir -p /etc/Lawnetwork

# Checking if there is another autoscript installed
clear
if [ -f "/etc/xray/domain" ]; then
    echo ""
    echo -e "[ ${green}INFO${none}    ] Script is already installed!"
    echo -ne "[ ${yellow}WARNING${none} ] Do you want to install the script again? (y/n): "
    read answer
    if [ "$answer" == "${answer#[Yy]}" ]; then
        rm -rf /root/Autoscript
        sleep 10
        exit 0
    else
        clear
    fi
elif [ -f "/usr/local/etc/xray/config.json" ]; then
    echo ""
    echo -e "[ ${red}WARNING${none} ] Another Xray Script is already installed, please rebuild your VPS!"
    sleep 2
    echo ne "[ ${red}WARNING${none} ] Do you want to exit the script? (y/n): "
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
        rm -r /root/Autoscript
        sleep 10
        exit 0
    fi
fi

# Installing dependencies
cd /root/Autoscript/addons; ./dependencies.sh
cd

# Adding a domain
clear
yellow "Adding a Domain"
echo " "
read -rp "Input your domain: " -e domain
echo "$domain" > /root/domain
echo "$domain" > /root/scdomain
echo "$domain" > /etc/xray/domain
echo "$domain" > /etc/xray/scdomain
echo "IP=$domain" > /var/lib/Lawnet-pro/ipvps.conf

# Adding themes
#mkdir -p /etc/Lawnetwork/theme
cd /root/Autoscript/addons; ./theme.sh
cd

===================================================

# Installing SSH and XRAY
clear

#SSH
echo -e "${blue}
===================================================
|             PROCESS INSTALLING SSH              |
==================================================="
sleep 3; cd /root/Autoscript/ssh; ./ssh.sh
cd
clear

#XRAY
echo -e "${blue}
===================================================
|             PROCESS INSTALLING XRAY             |
==================================================="
sleep 3; cd /root/Autoscript/xray; ./xray.sh
cd
clear

#Websocket
echo -e "${blue}
===================================================
|           PROCESS INSTALLING WEBSOCKET          |
==================================================="
sleep 3; cd /root/Autoscript/ssh; ./ws.sh
cd
clear

#OHP
echo -e "${blue}
===================================================
|              PROCESS INSTALLING OHP             |
==================================================="
#sleep 3; cd ~/Autoscript/ssh; ./ohp.sh
yellow "[ BECAUSE OF I DISABLED THE OVPN, SO WE CAN SKIP THIS STEP ]"
yellow "[ DM ME ON TELEGRAM IF YOU WANT TO INSTALL OPENVPN ]"; sleep 3
clear

#AutoBackup
echo -e "${blue}
===================================================
|          PROCESS INSTALLING AUTOBACKUP          |
==================================================="
sleep 3; cd /root/Autoscript/addons; ./set-br
cd
clear

#Menu
echo -e "${blue}
===================================================
|             PROCESS INSTALLING MENU             |
==================================================="
sleep 3; cd /root/Autoscript/menu; ./menu.sh
cd
clear

cp /root/Autoscript/update.sh /usr/bin/update


#================ LawNetwork ================#

cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
#menu
vnstat -d
vnstat -m
END
chmod 644 /root/.profile

#================ LawNetwork ================#

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
serverV="0.1 Beta Mei 2023"
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
curl -sS ifconfig.me > /etc/myipvps

#================ LawNetwork ================#

clear

# Enabling autorefresh xray online login
cd
mv /root/Autoscript/xray/clear-log /usr/bin
cd /root/Autoscript/addons; ./crontab
cd
clear

# Addons
mv /root/Autoscript/addons/xp.sh /usr/bin/xp
mv /root/Autoscript/addons/auto-set /usr/bin/auto-set
if [ -f /usr/bin/auto-set ]; then
clear
else
wget -O /usr/bin/auto-set https://raw.githubusercontent.com/LawNetwork/Autoscript/main/addons/auto-set
fi
#mv /root/Autoscript/addons/autoreboot /usr/bin/autoreboot (Improved using menu-set)
cd /root/Autoscript/addons; ./speedtest
cd


# Setting up new vps login port (error on )
#clear
#echo -ne "Do you want to change the VPS login Authentication? (y/n): "; read lgn
#if [ "$lgn" == "${lgn[Yy]}" ]; then
#read -
#sed -i '/Port 22/a Port 5432' /etc/ssh/sshd_config
#sed -i 's/#Port 22/Port 5432/g' /etc/ssh/sshd_config
#/etc/init.d/ssh restart
#service ssh restart
#service sshd restart
#fi

clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "=========================[SCRIPT PREMIUM]========================"
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI SSH ]" | tee -a log-install.txt
echo "    -------------------------" | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - Stunnel4                : 447, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - SSH Websocket           : 80"  | tee -a log-install.txt
echo "   - SSH SSL Websocket       : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI  Badvpn, Nginx]" | tee -a log-install.txt
echo "    ---------------------------" | tee -a log-install.txt
echo "   - Badvpn                  : 7100-7900"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI Shadowsocks-R & Shadowsocks]"  | tee -a log-install.txt
echo "    ---------------------------------------" | tee -a log-install.txt
echo "   - Websocket Shadowsocks   : 443"  | tee -a log-install.txt
echo "   - Shadowsocks GRPC        : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI XRAY]"  | tee -a log-install.txt
echo "    ----------------" | tee -a log-install.txt
echo "   - Xray Vmess Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vless Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vmess Ws None Tls  : 80"  | tee -a log-install.txt
echo "   - Xray Vless Ws None Tls  : 80"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI TROJAN]"  | tee -a log-install.txt
echo "    ------------------" | tee -a log-install.txt
echo "   - Websocket Trojan        : 443"  | tee -a log-install.txt
echo "   - Trojan GRPC             : 443"  | tee -a log-install.txt
echo "   --------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Auto Reboot On           : $aureb:00 $gg GMT +7" | tee -a log-install.txt
echo "   - Custom Path " | tee -a log-install.txt
echo "   - Auto Backup Data" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully Automatic Script" | tee -a log-install.txt
echo "   - VPS Settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Backup & Restore Data" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "=========================[SCRIPT PREMIUM]========================"
echo ""
sleep 3
echo -e "    ${blue}.------------------------------------------.${NC}"
echo -e "    ${blue}|     SUCCESFULLY INSTALLED THE SCRIPT     |${NC}"
echo -e "    ${blue}'------------------------------------------'${NC}"
echo ""
echo -ne "   ${blue}Do you want to restart now? (y/n): {NC}"; read rstrt

mv /root/Autoscript/version /root/version
mv /root/Autoscript/menu/regionchecker /usr/bin/regionchecker
mv /root/Autoscript/menu/benchmark /usr/bin/benchmark

rm /root/cf.sh >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /root/insshws.sh 
rm /root/update.sh
rm -rf /root/Autoscript
#sleep 10
if [ $rstrt == $rstrt[Yy] ]; then
reboot
else
menu
fi