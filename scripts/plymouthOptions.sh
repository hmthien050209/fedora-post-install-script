#! /bin/bash
# ./scripts/plymouthOptions.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 Licens

HEIGHT=25
WIDTH=100
CHOICE_HEIGHT=4
BACKTITLE="Fedora post-install script by davidhoang05022009 (Hoàng Minh Thiên)"
MENU_MSG="Please select one of following options:"

PLYMOUTH_OPTIONS=(
    1  "Disable quiet boot screen"
    2  "Just display vendor logo at boot (disable plymouth)"
    3  "Go back to main menu"
)

while true; do
    PLYMOUTH_CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE - Plymouth options menu $(lscpu | grep -i "Model name:" | cut -d':' -f2- - )" \
        --title "$TITLE" \
        --nocancel \
        --menu "$MENU_MSG" \
        "$HEIGHT" "$WIDTH" "$CHOICE_HEIGHT" \
        "${PLYMOUTH_OPTIONS[@]}" \
        2>&1 >/dev/tty)
    clear

    case $PLYMOUTH_CHOICE in
        1) echo "Disabling quiet boot screen"
        while true; do
            read -rp "Do you want to install grub themes in the future? [y/N]: " yn
            case $yn in
            [Yy]*) 
            sudo cp /etc/default/grub /etc/default/grub.bak
            sudo cp dotfiles/grub/grub-quiet-theme-compatible /etc/default/grub
            break
            ;;  
            
            *) 
            sudo cp /etc/default/grub /etc/default/grub.bak
            sudo cp dotfiles/grub/grub-quiet /etc/default/grub 
            break
            ;;
            esac
        done
        update_grub
        sudo plymouth-set-default-theme details 
        sudo dracut -f --debug
        notify-send "Disabled quiet boot screen"
        read -rp "Press any key to continue" _
        ;;
         
        2) echo "Disabling plymouth"
        while true; do
            read -rp "Do you want to install grub themes in the future? [y/N]: " yn
            case $yn in
            [Yy]*) 
            sudo cp /etc/default/grub /etc/default/grub.bak
            sudo cp dotfiles/grub/grub-plymouth-disable-theme-compatible /etc/default/grub
            break
            ;;  
            
            *) 
            sudo cp /etc/default/grub /etc/default/grub.bak
            sudo cp dotfiles/grub/grub-plymouth-disable /etc/default/grub 
            break
            ;;
            esac
        done
        update_grub
        sudo systemctl disable plymouth-quit-wait.service
        echo "3 3 3 3" | sudo tee /proc/sys/kernel/printk
        echo "kernel.printk = 3 3 3 3" | sudo tee -a /etc/sysctl.conf
        sudo dracut -f --debug
        notify-send "Disabled plymouth"
        read -rp "Press any key to continue" _
        ;;
        
        3) break
        ;;
    esac
done