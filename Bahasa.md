# Autoscript by LawNET (ID)
English click [here](README.md)

## Sebelum Install Autoscript
Sebelum menginstall Autoscript ini, pastikan kamu punya setidaknya 1 buah vps server dengan OS yang sudah diinstall Debian 10. Lebih bagus jika punya panel sendiri, biar lebih gampang install ulang aja kalau nanti nemu error saat install script ini.

Copy paste kode di bawah ini sebelum menginstall Autoscriptnya (Pastikan login menggunakan root jangan debian):
```
apt update; apt install -y git curl; apt upgrade -y; update-grub; reboot
```

## Install
Login ulang vpsmu, sekarang servermu siap diinstall Autoscript, silakan copy paste kode di bawah, pastikan dijawab y atau n jika ada opsi (y/n) sesuai kebutuhan:
```
cd; git clone https://github.com/LawNetwork/Autoscript.git; chmod +x /root/Autoscript/*; cd Autoscript; ./setup.sh
```

## Setelah Install Autoscript
Hapus semua file Installer yang ada di vpsmu(tidak wajib):
```
rm -r /root/Autoscript
```

## Update
Autoscript ini masih dalam tahap beta, kemungkinan banyak bug masih ada, tetapi saya pastikan semua serive berjalan normal.

Jika ada update mendatang, akan saya perbarui lewat kode di bawah:
#### Script version: v0.1 Beta Mei 2023
```
wget raw.githubusercontent.com/LawNetwork/Autoscript/update.sh; chmod +x update.sh; ./update.sh
```
Dm saya di Telegram [klik disini](https://t.me/Law_sky) jika mendapati error saat meningstal Autoscript atau terdapat bug pada Autoscript yang sudah terinstall di server kamu.


Thanks for using our Script!
