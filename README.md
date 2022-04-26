# The Simple OS

## Description

A Linux distro that's heavily modified to improve user experience.

The project contains:
- Protection of system-level changes and management through a single "System Manager" application
- User applications forced into a specific setup contained in their own user
- Custom Desktop Environment
- Custom package manager for user applications
- A UX-focused distro built on AppImages
- Status tray tools for Wifi/Ethernet management, Sound management, and Bluetooth management

## Building

Dependencies:
- Arch Linux base install
- cargo installed on said base system

Build:
1. Launch archiso
2. Connect to internet via `wifi-menu`
3. Run `sudo pacman -Sy`
4. Run `sudo pacman -S git glibc`
5. Clone this repo: `git clone https://github.com/blueOkiris/sos`
6. Run `chmod +x sos/install.sh`
7. Run `./sos/install.sh <hard drive you want to install to>`
