#!/bin/bash

set -e

echo "Checking permissions..."
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

pacman-key --init
pacman-key --populate archlinux
if ! grep -q "archlinuxcn" /etc/pacman.conf; then
    echo -e "\n[archlinuxcn]\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
fi
pacman -Sy --noconfirm archlinuxcn-keyring

echo "Starting Build..."
mkarchiso -v -w work -o out .
