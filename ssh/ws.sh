#!/bin/bash

source /root/Autoscript/addons/color.sh

cd; clear
rm /usr/local/bin/ws-dropbear
rm /usr/local/bin/ws-stunnel
cp /root/Autoscript/ssh/dropbear-ws.py /usr/local/bin/ws-dropbear
cp /root/Autoscript/ssh/ws-stunnel /usr/local/bin/ws-stunnel

rm /etc/systemd/system/ws-dropbear.service
rm /etc/systemd/system/ws-stunnel.service
cp /root/Autoscript/ssh/service-wsdropbear /etc/systemd/system/ws-dropbear.service
cp /root/Autoscript/ssh/ws-stunnel.service /etc/systemd/system/ws-stunnel.service

systemctl daemon-reload
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service