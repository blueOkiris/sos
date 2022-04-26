# Author: Dylan Turner
# Description: A script that runs on the arch iso (home dir) and creates a SOS install

# Update system time
timedatectl set-ntp true

# Set up disks
## First paramater is hard drive to install to

## Create new partition table
parted -s ${1} mktable gpt

## Create the EFI partition
parted -s ${1} mkpart primary fat32 0% 512M

## Create the root partition
## I've chosen no swap. I don't think it's needed on Desktop Linux tbh (uesful on servers tho)
parted -s ${1} mkpart primary ext4 513M 100%

## Format
mkfs.fat -F 32 ${1}1
mkfs.ext4 ${1}2

## Mount
mount ${1}2 /mnt
mkdir /mnt/boot
mount ${1}1 /mnt/boot

# Install base system
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# Copy files over
cp -r sos /mnt/

# Run secondary install script
arch-chroot /mnt ./install-chroot.sh
