#!/bin/bash

# pacman
systemctl disable reflector
echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
sed -i 's/^CheckSpace/#CheckSpace/g' /etc/pacman.conf
pacman-key --init
echo '[archlinuxcn]' >> /etc/pacman.conf
echo 'Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf

# user
USERNAME="archiso"
PASSWORD="archiso"
useradd -m -G wheel -s /bin/zsh $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
# nopasswd
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel

# tty
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat <<EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear %I $TERM
EOF

# sddm autologin
systemctl disable sddm
mkdir -p /etc/sddm.conf.d
cat <<EOF > /etc/sddm.conf.d/autologin.conf
[Autologin]
User=$USERNAME
Session=plasma
Relogin=false
EOF

# disable kde wallet
mkdir -p /home/$USERNAME/.config
cat <<EOF > /home/$USERNAME/.config/kwalletrc
[Wallet]
Enabled=false
First Use=false
EOF
chown -R $USERNAME:$USERNAME /home/$USERNAME/.config

# services
systemctl enable NetworkManager
systemctl enable dhcpcd
systemctl enable bluetooth

# zimfw
chsh -s /bin/zsh root
sudo -u $USERNAME bash -c 'cd ~ && curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh'


# aur
sudo -u $USERNAME paru -S --noconfirm --needed google-chrome v2rayn-bin fcitx5-input-support

