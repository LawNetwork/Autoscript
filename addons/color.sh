#!/bin/bash

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


#Addons
plain='\033[0m'

##These colors below are available for all the menus when they are calling
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[ON]${Font_color_suffix}"
Error="${Red_font_prefix}[OFF]${Font_color_suffix}"