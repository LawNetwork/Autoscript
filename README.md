# Autoscript by LawNET (ENG)
Bahasa Indonesia klik [disini](Bahasa.md)

## Pre-Install
Before you installing this Autoscript, make sure you have atleast 1 vps with Debian 10 OS Installed. A vps panel better to install-reinstalling the vps if you are facing errors in future.

Paste this code before installing the Installer (Make sure you log into your vps using root):
```
apt update && apt install -y git curl && apt upgrade -y && update-grub && reboot
```

## Install
Relog into your vps again using root, then paste this code to start installing the Autoscript:
```
cd && git clone https://github.com/LawNetwork/Autoscript.git && chmod +x /root/Autoscript/* && cd Autoscript && ./setup.sh
```

## After-Install
Deleting all installer files:
```
rm -r /root/Autoscript
```

## Update
This script still is in beta, all updates will be shown below
#### Script version: 0.1 Beta May 2023
```
wget raw.githubusercontent.com/LawNetwork/Autoscript/update.sh && chmod +x update.sh && ./update.sh
```



Dm me on Telegram [click here](https://t.me/Law_sky) if you are still facing any errors.

Thanks for using our Script!
