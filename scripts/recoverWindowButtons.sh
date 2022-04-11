#! /bin/bash
# ./scripts/recoverWindowButtons.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

echo "Recovering maximize, minimize button"
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
notify-send "Recovered maximiaze, minimize button"
read -rp "Press any key to continue" _