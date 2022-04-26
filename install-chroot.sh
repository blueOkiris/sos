# Author: Dylan Turner
# Description: Secondary install script to run commands while under chroot

# Update

pacman -Syu

# Build rust project

## Install cargo
pacman -S cargo

## Build rust project
cd /sos
cargo build --release
