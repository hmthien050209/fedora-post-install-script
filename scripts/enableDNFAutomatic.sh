#! /bin/bash
# ./scripts/enableDNFAutomatic.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

echo "Enabling dnf-automatic(Automatic updates)"
sudo dnf install dnf-automatic -y
sudo cp dotfiles/dnf/automatic.conf /etc/dnf/automatic.conf
sudo systemctl enable --now dnf-automatic.timer
notify-send "Enabled dnf-automatic"
read -rp "Press any key to continue" 