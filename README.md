# The Simple OS

## Description

A Linux distro that's heavily modified to improve user experience.

The project contains:
- Protection of system-level changes and management through a single "System Manager" application
- User applications forced into a specific setup contained in their own user using AppImages
- Custom package manager for enforcing user applications
- Install scripts for building off of Arch
- File browser (bc therer aren't any flatpak file browsers out there)

## Building Custom Iso

Dependencies:
- Arch Linux
- archiso

1. Copy `/usr/share/archiso/configs/releng` to somewhere (Note: it's a directory)
2. Clone this repo into the `airootfs/root/` subfolder
3. Run `sudo mkarchiso <path to custom releng folder>`

## Installing

To install:
1. Boot up the Simple OS iso (you can get it from releases or build it yourself)
2. Connect to the internet [like you would with an Arch Iso](https://wiki.archlinux.org/title/Network_configuration/Wireless#iw)
3. Run `./sos/install.sh <hard drive you want to install to> <region/timezone (from /usr/share/zoneinfo/region/timezone> <admin password> <username> <your password>` e.g. `./sos/install.sh /dev/sda US/Central secure_password blueOkiris password`

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
