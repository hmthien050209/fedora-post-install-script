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
\nseahorse \nclang \ncmake \nninja-build \npkg-config \ngtk3-devel \nxz-devel \nvariety \nDiscord with BetterDiscord and Dracula theme \nSignal \nTelegram \nRemmina \nGeoGebra \nBitwarden \nDocker and Docker Desktop for Linux (Rootless) \
\nFirfox and Google Chrome from Flatpak \x1B[31m(WILL REMOVE NORMAL FIREFOX AND GOOGLE CHROME PACKAGE)\x1B[0m\n"
echo -e "And then set Firefox Flatpak as the default browser"
while true; do
    read -rp "Continue? [y/N]: " yn
    
    case $yn in
    [Yy]*) 
        echo "Installing my daily apps"
        
        echo -e "[anydesk]\nname=AnyDesk Fedora - stable\nbaseurl=http://rpm.anydesk.com/fedora/\$basearch/\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY" \
         | sudo tee /etc/yum.repos.d/AnyDesk-Fedora.repo

        sudo dnf config-manager --add-repo "https://download.docker.com/linux/fedora/docker-ce.repo"
        sudo dnf --releasever=32 install pangox-compat.x86_64
        sudo dnf makecache
        # I use Google Chrome and Firefox from Flatpak so uninstall the normal version of it
        sudo dnf remove firefox google-chrome-stable -y

        sudo dnf install redhat-lsb-core anydesk vlc obs-studio @virtualization shotcut seahorse clang cmake ninja-build pkg-config gtk3-devel xz-devel variety docker-ce \
        docker-ce-cli containerd.io docker-compose-plugin fuse-overlayfs iptables -y

        # Make sure there isn't any running Docker-related service
        sudo systemctl disable --now docker.service docker.socket

        # Run the Docker rootless setup script
        dockerd-rootless-setuptool.sh install

        # Start the daemon as a rootless user
        systemctl --user start docker
        docker context use rootless

        # Download the Docker Desktop
        axel -n 20 "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.9.1-x86_64.rpm"
        
        flatpak install flathub com.discordapp.Discord org.signal.Signal org.telegram.desktop org.remmina.Remmina org.geogebra.GeoGebra com.bitwarden.desktop com.google.Chrome org.mozilla.Firefox
        curl -O "https://raw.githubusercontent.com/bb010g/betterdiscordctl/master/betterdiscordctl"
        chmod +x betterdiscordctl
        sudo mv betterdiscordctl /usr/local/bin
        betterdiscordctl --d-install flatpak install
        curl "https://raw.githubusercontent.com/dracula/betterdiscord/master/Dracula.theme.css" -o ~/.var/app/com.discordapp.Discord/config/BetterDiscord/themes/Dracula.theme.css
        
        # Set Flatpak Firefox as the default browser
        xdg-settings set default-web-browser org.mozilla.firefox.desktop

        if [ "$(rpm -q virt-manager 2>/dev/null | grep -c "is not installed")" -eq 1 ]; 
        then
            echo "Virt-manager is not installed, skipping configuring virt-manager"
        else
            echo "Configuring virt-manager"
            echo -e "\nunix_sock_group = \"libvirt\"\nunix_sock_rw_perms = \"0770\""
            sudo systemctl start libvirtd
            sudo systemctl enable libvirtd
            sudo usermod -a -G libvirt "$(whoami)"
            echo "Remember to re-login before using virt-manager"
        fi
        echo "Done configuring and install my daily apps"
        echo "Make sure to add /usr/bin to PATH variable and set DOCKER_HOST=unix:///run/user/1000/docker.sock"
        echo "For fish shell: open ~/.config/fish/config.fish, add \
        set -gx DOCKER_HOST \"unix:///run/user/1000/docker.sock\" below the \"if status is-interactive\" line"
        
        break
    ;; 

    *) 
        echo "Aborted"
        break
    ;;
    esac
done

read -rp "Press any key to continue" _