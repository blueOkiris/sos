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
echo ${2} | passwd --stdin root

# Install bootloader

echo "Installing bootloader."
bootctl install

# Build rust project

echo "Building sos project."

## Install system dependencies for our project
echo "Installing dependencies for Rust code."
pacman -S gtk4 pkg-config --noconfirm

## Install cargo
pacman --noconfirm -S cargo

## Build rust project
echo "Build start."
cd /sos
cargo build --release
cd ..

# Set up users and sysman

## Install and set up sudo

pacman --noconfirm -S sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

## Install sysman
echo "Installing System Manager."
mkdir /app
useradd -m -G wheel -s /bin/bash -b /app sysman
cp /sos/target/release/sysman /app/sysman
echo "System Manager,0,sysman,/app/sysman,sysman" > /app
echo ${2} | passwd --stdin sysman

## Creating user (No root access FYI)
echo "Creating user ${3}."
pacman --noconfirm -S zsh
useradd -m -s /bin/zsh -b /home ${3}
echo ${4} | passwd --stdin ${3}

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
