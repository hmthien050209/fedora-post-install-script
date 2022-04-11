#! /bin/bash
# ./scripts/installPopShell.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

echo "Installing Pop Shell"
sudo dnf install gnome-shell-extension-pop-shell xprop -y
echo "Enabling Pop Shell"
gnome-extensions enable pop-shell@system76.com # may need to go to extensions to enable
gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true
gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba "rgb(66,103,212)"
gsettings set org.gnome.shell.extensions.pop-shell gap-outer 0
gsettings set org.gnome.shell.extensions.pop-shell gap-inner 0
notify-send "Installed and enabled Pop Shell, if you're using Wayland, re-login and go to Extensions to enable it"
read -rp "Press any key to continue" _