#!/bin/bash

clear
source /root/Autoscript/color.sh

date
domain=$(cat /root/domain)

mkdir -p /etc/xray
echo -e "[ ${green}INFO${none} ] Checking..."; apt install -y iptables iptables-persistent; sleep 1
echo -e "[ ${green}INFO${none} ] Setting up ntpupdate"; ntpupdate pool.ntp.org; timedatectl set-ntp true; sleep 1
echo -e "[ ${green}INFO${none} ] Enabling chronyd"; systemctl enable chronyd; systemctl restart chronyd; sleep 1
echo -e "[ ${green}INFO${none} ] Enable chrony"; systemctl enable chrony; systemctl restart chrony; timedatectl set-timezone Asia/Jakarta; sleep 1
echo -e "[ ${green}INFO${none} ] Setting chrony tracking"; chronyc sourcestats -v; chronyc tracking -v

echo -e "[ ${green}INFO${none} ] Setting up others"
apt clean all && apt update
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
apt install curl pwgen openssl netcat cron -y

# Installing XRAY
clear
cd
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
mkdir -p /var/log/xray
mkdir -p /etc/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log

## Getting the official latest update of xray core version
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v1.7.5/xray-linux-64.zip"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version

## Certing xray
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

## Renewing ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

mkdir -p /home/vps/public_html

## Setting up UUID
uuid=$(cat /proc/sys/kernel/random/uuid)

## Configuring xray
cd /root/Autoscript/xray; ./xrayconf.sh
cd

## Configuring services
rm -rf /etc/systemd/system/xray.service.d
cd /root/Autoscript/xray; ./xrayservice.sh
cd

echo -e "[ ${green}INFO$NC ] Installing bbr.."
mv /root/Autoscript/xray/bbr.sh /usr/bin/bbr
bbr >/dev/null 2>&1
rm /usr/bin/bbr >/dev/null 2>&1
echo -e "$yell[SERVICE]$NC Restart All service"
systemctl daemon-reload
sleep 1
echo -e "[ ${green}ok${NC} ] Enable & restart xray "
systemctl enable xray
systemctl restart xray
systemctl restart nginx
systemctl enable runn
systemctl restart runn

rm /usr/bin/auto-set
mv /root/Autoscript/addons/auto-set /usr/bin/auto-set
mv /root/Autoscript/xray/certxray.sh /usr/bin/certxray

cd
clear
yellow "xray/Vmess"
yellow "xray/Vless"
sleep 1

cp /root/domain /etc/xray/ 
if [ -f /root/scdomain ];then
rm /root/scdomain > /dev/null 2>&1
fi
clear