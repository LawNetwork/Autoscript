#!/bin/bash

source /root/color

scversion=$(curl -sS https://raw.githubusercontent.com/LawNetwork/Autoscript/main/version);
scvpsversion=$(cat /root/version);

if [ "$scversion" = "$scvpsversion" ]; then
clear
echo -e "${green}There is no update available yet"; sleep 1
echo -e "${green}Feel free to give us any suggestions on what other features can we add into"; skeep 1
echo ""
echo -e "${yellow}Contact us at https://t.me/Law_sky"
echo ""
echo ""; sleep 5
echo -ne "${none}Press enter to go back" read bck
if [ -z "$bck" ]; then
    clear
fi

fi
menu