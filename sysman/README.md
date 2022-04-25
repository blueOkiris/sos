# System Manager Application

## Description

__Packages:__

When it comes to packages, the purpose of the application is four-fold:
1. Install applications as users
    - Home dir under /app
    - Main binary in /app/\<appname\>/run and icon under /app/\<appname\>/icon
    - App info stored in /etc/appinfo:
        + Name and home dir
    - Look for url to package data from github repo
    - Manage dependencies via pacman
2. Install tray items (single binaries that install to /trayitems)
3. Manage an interface to underlying pacman for libraries, services, and drivers
    - Keep track of all application using a specific arch package and uninstall if not used
    - Note that that doesn't apply to packages that are preinstalled. Basically, do "if !preinstalled && !depended_on { uninstall() }"
4. Install and update drivers, libraries, and services
    - List of "approved" Arch driver packages in /etc/valid-arch/drivers
    - List of "approved" Arch service packages in /etc/valid-arch/services
    - Libraries only installed as dependencies

__Services:__

The app is also used for enabling/disabling services
