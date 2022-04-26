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
    - Use predominantly appimages
2. Install tray items (single binaries that install to /trayitems)
3. Install and update system-level items

__Services:__

The app is also used for enabling/disabling services
