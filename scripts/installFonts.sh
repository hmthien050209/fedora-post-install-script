#! /bin/bash
# ./scripts/installFonts.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

echo "Installing Google Noto Sans fonts, Microsoft Cascadia Code fonts and apply it to system fonts"
sudo dnf install google-noto-sans-fonts -y
axel -n 20 https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip
unzip ./CascadiaCode-2110.01.zip -d ./CascadiaCode-2110.01
sudo mv ./CascadiaCode-2110.01/ttf/static/* /usr/share/fonts/
fc-cache -f -v
gsettings set org.gnome.desktop.interface font-name 'Noto Sans Medium 11'
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans Regular 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Cascadia Code PL 13'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Noto Sans Bold 11'
notify-send "Installed Google Noto Sans fonts, Microsoft Cascadia Code fonts and applied it to system fonts"
read -rp "Press any key to continue" _