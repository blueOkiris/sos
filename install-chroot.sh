# Author: Dylan Turner
# Description: Secondary install script to run commands while under chroot

# Update

echo "Updating."

## Update mirrolist
#echo "Configuring mirrorlist. This may take a while :/"
#pacman --noconfirm -Sy
#pacman --noconfirm -S pacman-contrib
#curl -s "https://archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -

## Update
#echo "Okay. Actually updating now!"
pacman --noconfirm -Syu

# Set timezone and locale

echo "Setting up locale."

## Set time zone (parameter 1)
ln -sf /usr/share/zoneinfo/${1} /etc/localtime
hwclock --systohc

## Localization setup
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

## Set hostname
echo "sossi-boi" > /etc/hostname

# Set root password
## 2nd param
echo "root:${2}:" | chpasswd

# Install bootloader

echo "Installing bootloader."
bootctl install
systemctl enable systemd-boot-update

echo "Adding boot entry."
cat >> /boot/loader/entries/arch.conf<< EOF
title   Simple OS
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root="/dev/sda2" rw
EOF

# Set up users and rust apps

## Install and set up sudo

pacman --noconfirm -S sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

## Build rust project

echo "Building sos project."

### Install system dependencies for our project
echo "Installing dependencies for Rust code."
pacman -S gtk4 pkg-config --noconfirm

### Install cargo
pacman --noconfirm -S cargo

### Build rust project
echo "Build start."
cd /sos
cargo build --release
cd ..

## Install sysman
echo "Installing System Manager."
mkdir /app
useradd -m -G wheel -s /bin/bash -b /app sysman
cp /sos/target/release/sysman /app/sysman
echo "System Manager,0,sysman,/app/sysman,sysman" > /app
echo "sysman:${4}" | chpasswd

## Install appimage of fileman
echo "Packaging File Manager as AppImage."
cd /sos/fileman
wget https://github.com/TheAssassin/appimagecraft/releases/download/continuous/appimagecraft-x86_64.AppImage
chmod +x appimagecraft-x86_64.AppImage
DEPLOY_GTK_VERSION=4 ./appimagecraft-x86_64.AppImage
cd ../..

echo "Installing File Manager."
mkdir /app
useradd -m -s /bin/bash -b /app fileman
cp /sos/fileman/File_Manager-0-x86_64.AppImage /app/fileman
echo "File Manager,0,fileman,/app/fileman,File_Manager-0-x86_64.AppImage" >> /app

## Install appimage of fileman
echo "Packaging App Launcher as AppImage."
cd /sos/launcher
cp ../fileman/appimagecraft-x86_64.AppImage .
DEPLOY_GTK_VERSION=4 ./appimagecraft-x86_64.AppImage
cd ../..

echo "Installing App Launcher."
mkdir /app
useradd -m -s /bin/bash -b /app launcher
cp /sos/launcher/App_Launcher-0-x86_64.AppImage /app/launcher
echo "App Launcher,0,launcher,/app/launcher,App_Launcher-0-x86_64.AppImage" >> /app

## Creating user (No root access FYI)
echo "Creating user ${3}."
pacman --noconfirm -S zsh
useradd -m -s /bin/zsh -b /home ${3}
echo "${3}:${4}" | chpasswd

## Set up oh-my-zsh
echo "Setting up zsh."
pacman --noconfirm -S git curl
cd /home/${3}
su -c "curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh" ${3}
su -c "git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions" ${3}
su -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ${3}
su -c "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ${3}
cd ..

## Set default zshrc to something simple, but nice
rm -rf /home/${3}/.zshrc
cat >> /home/${3}/.zshrc<< EOF
export ZSH="/home/${3}/.oh-my-zsh"
ZSH_THEME="gentoo"

zstyle ':omz:update' mode auto # update automatically without asking

plugins=(git zsh-completions zsh-syntax-highlighting zsh-autosuggestions)
autoload -U compinit && compinit

source \$ZSH/oh-my-zsh.sh

# User configuration
export PATH="/home/${3}/.local/bin:\$PATH"
export EDITOR=vim
EOF
pacman --noconfirm -S vim
chown ${3}: /home/${3}/.zshrc

# Desktop setup

echo "Setting up desktop environment."

## Install xfwm4, xfce4-panel, etc (stuff that's not this project)
pacman --noconfirm -S xorg xorg-xinit xfce4 lightdm lightdm-webkit2-greeter
### Install and uninstall xfce4 so all the config for a DE gets set up.
### Seems to be the easiest way
pacman --noconfirm -R xfce4
### Then install the xfce4 stuff we're using
pacman --noconfirm -S xfce4-panel xfce4-terminal \
    xfwm4 xfce4-datetime-plugin xfce4-pulseaudio-plugin xfce4-fsguard-plugin xfce4-battery-plugin \
    ttf-ubuntu-font-family papirus-icon-theme arc-gtk-theme
cd sos
git clone https://aur.archlinux.org/lightdm-webkit2-theme-glorious.git
cd lightdm-webkit2-theme-glorious
chown sysman: .
su -c "makepkg -Acs" sysman
pacman --noconfirm -U *.pkg.tar.zst
cd ../..

## Set up lightdm
echo "Setting up display manager."
sed -i 's/antergos/glorious/g' /etc/lightdm/lightdm-webkit2-greeter.conf
sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf
systemctl enable lightdm.service

## Set up DE
cat >> /etc/sos-desktop.sh<< EOF
#!/bin/bash
xfwm4 &
xfce4-panel
EOF
chmod +x /etc/sos-desktop.sh
mkdir -p /usr/share/xsessions
cat >> /usr/share/xsessions/sos.desktop<< EOF
[Desktop Entry]
Version=0.0
Name=Simple OS Session
Comment=Use this to start the Simple OS Desktop
Exec=/etc/sos-desktop.sh
Icon=
Type=Application
DesktopNames=SimpleOS_DE
EOF

### Set up DE Configs
rm -rf /home/${3}/.config/xfce4
mkdir -p /home/${3}/.config
cp sos/xfce4-conf.tar.xz /home/${3}/.config
cp sos/.gtkrc-2.0 /home/${3}/.config
cd /home/${3}/.config/
tar xfzv xfce4-conf.tar.xz
chown -R ${3}: /home/${3}/.config
rm -rf /app/sysman/.config/xfce4
mkdir -p /app/sysman/.config
cp -r /home/${3}/.config/xfce4 /app/sysman/.config
cp sos/.gtkrc-2.0 /app/sysman/.config
chown -R sysman: /app/sysman/.config

## Install network stuff
echo "Setting up network tools."
pacman --noconfirm -S networkmanager network-manager-applet
systemctl enable NetworkManager.service

rm -rf sos
