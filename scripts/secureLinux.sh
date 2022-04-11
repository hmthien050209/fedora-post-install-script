#! /bin/bash
# ./scripts/secureLinux.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

echo "Enhancing your Linux system's security"
sudo dnf install ufw fail2ban -y
sudo systemctl enable --now ufw.service
sudo systemctl disable --now firewalld.service
git clone https://github.com/ChrisTitusTech/secure-linux
chmod +x ./secure-linux/secure.sh
sudo ./secure-linux/secure.sh
notify-send "Enhanced your Linux system's security"
read -rp "Press any key to continue" _