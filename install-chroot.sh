# Author: Dylan Turner
# Description: Secondary install script to run commands while under chroot

# Update

## Update mirrolist
pacman -Sy
pacman -S pacman-contrib
curl -s "https://archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -

## Update
pacman -Syu

# Set timezone and locale

## Set time zone (parameter 1)
ln -sf /etc/share/zoneinfo/${1} /etc/localtime
hwclock --systohc

## Localization setup
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

## Set hostname
echo "sossi-boi" > /etc/hostname

# Set root password
## 2nd param
echo ${2} | passwd --stdin root

# Build rust project

## Install cargo
pacman -S cargo

## Build rust project
cd /sos
cargo build --release
