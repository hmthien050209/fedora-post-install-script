#! /bin/bash
# ./scripts/installMyDailyApps.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

echo -e "The script will install the following packages: \n\npangox-compat (Fedora 32) \nredhat-lsb-core \nanydesk \ngoogle-chrome-stable \nvlc \nobs-studio \n@virtualization \nshotcut \
\nseahorse \nclang \ncmake \nninja-build \npkg-config \ngtk3-devel \nxz-devel \nvariety \nDiscord with BetterDiscord and Dracula theme \nSignal \nTelegram \nRemmina \nGeoGebra \nBitwarden\n"
while true; do
    read -rp "Continue? [y/N]: " yn
    
    case $yn in
    [Yy]*) 
        echo "Installing my daily apps"
        
        echo -e "[anydesk]\nname=AnyDesk Fedora - stable\nbaseurl=http://rpm.anydesk.com/fedora/\$basearch/\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY" \
         | sudo tee /etc/yum.repos.d/AnyDesk-Fedora.repo

        sudo dnf --releasever=32 install pangox-compat.x86_64
        sudo dnf makecache
        sudo dnf install redhat-lsb-core anydesk -y
        sudo dnf install google-chrome-stable vlc obs-studio @virtualization shotcut seahorse clang cmake ninja-build pkg-config gtk3-devel xz-devel variety
        
        flatpak install flathub com.discordapp.Discord org.signal.Signal org.telegram.desktop org.remmina.Remmina org.geogebra.GeoGebra com.bitwarden.desktop
        curl -O https://raw.githubusercontent.com/bb010g/betterdiscordctl/master/betterdiscordctl
        chmod +x betterdiscordctl
        sudo mv betterdiscordctl /usr/local/bin
        betterdiscordctl --d-install flatpak install
        curl https://raw.githubusercontent.com/dracula/betterdiscord/master/Dracula.theme.css -o ~/.var/app/com.discordapp.Discord/config/BetterDiscord/themes/Dracula.theme.css
        
        if [ "$(rpm -q virt-manager 2>/dev/null | grep -c "is not installed")" -eq 1 ]; 
        then
            echo "Virt-manager is not installed, skipping configuring virt-manager"
        else
            echo "Configuring virt-manager"
            echo -e "\nunix_sock_group = \"libvirt\"\nunix_sock_rw_perms = \"0770\""
            sudo systemctl start libvirtd
            sudo systemctl enable libvirtd
            sudo usermod -a -G libvirt "$(whoami)"
            echo "Make sure to re-login before using virt-manager"
        fi
        echo "Done configuring and install my daily apps"
        break
    ;; 

    *) 
        echo "Aborted"
        break
    ;;
    esac
done

read -rp "Press any key to continue" _