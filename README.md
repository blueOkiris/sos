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
1. Boot into an [Arch install iso](https://archlinux.org/download/)
2. Connect to internet
3. Run `sudo pacman -Sy`
4. Run `sudo pacman -S git glibc`
5. Clone this repo: `git clone https://github.com/blueOkiris/sos`
6. Run `./sos/install.sh <hard drive you want to install to> <region/timezone (from /usr/share/zoneinfo/region/timezone> <root password>` i.e. `./sos/install.sh /dev/sda US/Central password`

## Installing Apps/Drivers Not in Official List

__Proper Path:__

In this OS you're not *supposed* to use the root account, though of course, you can. Ideally though, you should install apps through sysman, not pacman

So what if the app or driver you want doesn't exist? Then you should contribute to the project! Fork, make changes, and submit a pull request and make it better for everyone. It's super simple in this case

For apps, find an AppImage for what you want and add an entry to app-list.xml alla the ones that are already there. For drivers, add a new line with the Arch package you want supported.

I (Blue Okiris) will check you did it right, and then add it in, and then you should be able install your new package.

__Workaround:__

In the event I don't approve of your app or take too long, you can manually install an app.

Note that I do not recommend going down this path.

For drivers, log into the root acount, and install the package with pacman like you would with Arch Linux.

For apps, first create a user with the name of the app you want: `useradd -m /app/<appname> <appname>`, download the AppImage you want and place it in that directory, and then add an entry to `/etc/app/.list` with the format `<package name>,<package vers>,<appname>,/app/<appname>,<file name of downloaded AppImage`, e.g. `GIMP,0,gimp,/app/gimp,GIMP_AppImage-git-2.10.25-20210610-x86_64.AppImage`
