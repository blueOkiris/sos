# The Simple OS

## Description

A Linux distro that's heavily modified to improve user experience.

The project contains:
- Protection of system-level changes and management through a single "System Manager" application
- User applications forced into a specific setup contained in their own user using AppImages
- Custom package manager for enforcing user applications
- Install scripts for building off of Arch
- File browser (bc therer aren't any flatpak file browsers out there)
- Application launcher

## Installing

__Getting the Installer:__

You can grab an iso from Releases or make it yourself (below).

You need to [burn it to a USB drive](https://www.balena.io/etcher/), then [change your bios to boot to USB](https://recoverit.wondershare.com/windows-pe/how-to-set-computer-to-boot-from-usb-drive.html), and then boot into it.

__Selecting a Drive:__

After you boot into the live iso, you'll need to select the disk you want to install to. Most likely:
- if you have hard drives, it will be /dev/sda
- if you have an nvme ssd then it will be /dev/nvme0n1
- if installing to an SD Card it will probably be under /dev/mmcblk0
- if using gnome-boxes it'll be /dev/vda

To see what disks you have run the command `lsblk`. Ignore things like "loop0."

Warning: As it currently stands, it is not possible to set up manual partitions and the OS will install to use the entire disk. Either install over your existing OS, use a second hard drive, or use a USB stick/SD card (not the one you used for the iso)

__Running the Installer__

To install:
1. Connect to the internet [like you would with a standard Arch Linux iso](https://wiki.archlinux.org/title/Network_configuration/Wireless#iw)
2. Run `chmod +x sos/install.sh`
3. Run `bash -x sos/install.sh drive timezone root-password username password` where:
    - "drive" should be replaced with the drive you selected
    - "timezone" is one of the "Region/Timezone" pairs in [this list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List)
    - "root-password" is your administrative password. You will likely not use this much, so make it secure, write it down somewhere and forget about it
    - "username" is your user name for logging into the OS
    - "password" is the password for loging in with your user name
    - Example: `bash -x sos/install.sh /dev/sda US/Central secure_password blueOkiris password`

The script will restart your machine. Remove the installation media before it boots into it.

Unfortunately, the theme does not get set properly after install, so do these steps next:

4. Sign in with your password
5. Click your user name at the top right and select "Switch User"
6. Back in the login screen, click the power button and select restart
7. Sign in one more time, and you'll be good to go!

## Building Custom Iso

Dependencies:
- Arch Linux
- archiso

1. Copy `/usr/share/archiso/configs/releng` to somewhere (Note: it's a directory)
2. Clone this repo into the `airootfs/root/` subfolder
3. Run `sudo mkarchiso <path to custom releng folder>`

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
