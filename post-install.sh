#! /bin/bash
# ./post-install.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

HEIGHT=25
WIDTH=100
CHOICE_HEIGHT=4
BACKTITLE="Fedora post-install script by davidhoang05022009 (Hoàng Minh Thiên)"
MENU_MSG="Please select one of following options:"

# First, optimize the dnf package manager
sudo cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bak
sudo cp dotfiles/dnf/dnf.conf /etc/dnf/dnf.conf

# Check for updates
sudo dnf upgrade --refresh
sudo dnf autoremove -y
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update -y

# Install some tools required by the script
sudo dnf install axel deltarpm unzip -y

# Check if we have dialog installed
# If not, install it
if [ "$(rpm -q dialog 2>/dev/null | grep -c "is not installed")" -eq 1 ]; 
then
    sudo dnf install -y dialog
fi

OPTIONS=(
    1  "Install tools (Kitty requires Powerline-compatible fonts)"
    2  "Enable RPM Fusion"
    3  "Enable Flathub"
    4  "Install media codecs - Read more in README.md"
    5  "Install my daily apps"
    6  "Plymouth options ->"
    7  "Optimize booting time" 
    8  "Install auto-cpufreq (recommended for laptop users)"
    9  "Install Google Noto Sans fonts, Microsoft Cascadia Code fonts"
    10 "Install Fish with Tide (requires Powerline-compatible fonts)"
    11 "Install Dracula theme"
    12 "Recover maximize, minimize button"
    13 "Install GNOME Extensions (read more in README.md)"
    14 "Install ibus-bamboo (\"Bộ gõ tiếng Việt\" for Vietnamese users)"
    15 "Enable dnf-automatic (Automatic updates)"
    16 "Secure your Linux system (by Chris Titus Tech)"
    17 "Reboot"
    18 "Quit"
)

while true; do
    CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE - Main menu $(lscpu | grep -i "Model name:" | cut -d':' -f2- - )" \
                --title "$TITLE" \
                --nocancel \
                --menu "$MENU_MSG" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
    clear
    case $CHOICE in 
        1) 
            scripts/installTools.sh
        ;;
       
        2) 
            scripts/enableRPMFusion.sh
        ;;
        
        3)
            scripts/enableFlathub.sh
        ;;

        4) 
            scripts/installCodecs.sh
        ;;

        5) 
            scripts/installMyDailyApps.sh
        ;;

        6) 
            scripts/plymouthOptions.sh
        ;;

        7) 
            scripts/optimizeBootTime.sh
        ;;

        8) 
            scripts/installAuto-cpufreq.sh
        ;;

        9)
            scripts/installFonts.sh
        ;;

        10) echo "Installing Fish"
        sudo dnf install fish -y
        
        echo "Installing Fisher and Tide"
        "$(which fish)" scripts/fish/fisher_tide_install.sh

        notify-send "Installed Fish, Fisher and Tide"
        read -rp "Press any key to continue" _
        ;;

        11) 
            scripts/installDraculaTheme.sh
        ;;

        12) 
            scripts/recoverWindowButtons.sh
        ;;

        13) 
            scripts/installExtensions.sh
        ;;
        
        14) 
            scripts/installIbusBamboo.sh
        ;;
        
        15) 
            scripts/enableDNFAutomatic.sh
        ;;

        16) 
            scripts/secureLinux.sh
        ;;

        17)
            sudo systemctl reboot
        ;;

        18) rm -rf CascadiaCode*
            exit 0
        ;;

    esac
done
