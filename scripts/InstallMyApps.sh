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
\nFirfox from Flatpak \x1B[31m(WILL REMOVE NORMAL FIREFOX PACKAGE)\x1B[0m \nGoogle Chrome \nhtop \nneofetch \nxclip \ngnome-tweaks \nmicro \nVS Code \ngh \nkitty \nFlutter SDK (will be installed at ~/flutter)"
echo -e "\nAnd then set Firefox Flatpak as the default browser"
while true; do
    read -rp "Continue? [y/N]: " yn
    
    case $yn in
    [Yy]*) 
        echo "Installing my daily apps"
        
        sudo dnf config-manager --add-repo "https://download.docker.com/linux/fedora/docker-ce.repo"
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf config-manager --add-repo "https://cli.github.com/packages/rpm/gh-cli.repo"
        
        # Enable Google Chrome repository
        sudo dnf config-manager --set-enabled google-chrome
        sudo dnf makecache
        
        # I use Firefox from Flatpak so uninstall the normal version of it
        sudo dnf remove firefox -y

        # Download the Docker Desktop
        axel -n 20 "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.11.1-x86_64.rpm"

        sudo dnf install vlc obs-studio @virtualization shotcut seahorse clang cmake ninja-build pkg-config gtk3-devel xz-devel variety docker-ce \
        docker-ce-cli containerd.io docker-compose-plugin fuse-overlayfs iptables ./docker-desktop-4.11.1-x86_64.rpm google-chrome-stable \
        htop neofetch xclip gnome-tweaks micro code gh kitty -y

        # Make sure the downloaded GithubDesktop installer file isn't corrupted
        while true;
        do
            axel -n 20 "https://github.com/shiftkey/desktop/releases/download/release-3.0.2-linux1/GitHubDesktop-linux-3.0.2-linux1.rpm"
            if [ "$(sha256sum -c ./GithubDesktop-sha256sum.sha256)" == "GitHubDesktop-linux-3.0.2-linux1.rpm: OK" ]; then 
                sudo dnf install ./GitHubDesktop-linux-3.0.2-linux1.rpm -y
                break 
            fi
        done

        # Make sure there isn't any running Docker-related service
        sudo systemctl disable --now docker.service docker.socket

        # Run the Docker rootless setup script
        dockerd-rootless-setuptool.sh install

        # Start the daemon as a rootless user
        systemctl --user start docker
        docker context use rootless

        # Download appimaged for scanning AppImages
        axel -n 20 "https://github.com/probonopd/go-appimage/releases/download/continuous/appimaged-715-x86_64.AppImage" -o appimaged-x86_64.AppImage
        sudo mv ./appimaged-x86_64.AppImage /opt/
        
        # Download official Bitwarden AppImage
        axel -n 20 "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -o Bitwarden-x86_64.AppImage
        sudo mv ./Bitwarden-x86_64.AppImage /opt/

        # Initialize the appimaged
        chmod u+x /opt/*.AppImage
        /opt/appimaged-x86_64.AppImage
        
        flatpak install flathub org.signal.Signal org.telegram.desktop org.remmina.Remmina org.geogebra.GeoGebra org.mozilla.Firefox
        
        # Set Flatpak Firefox as the default browser
        xdg-settings set default-web-browser org.mozilla.firefox.desktop

        git clone https://github.com/flutter/flutter.git -b stable ~/flutter
        ~/flutter/bin/flutter precache
        ~/flutter/bin/flutter doctor

        if [ "$(rpm -q virt-manager 2>/dev/null | grep -c "is not installed")" -eq 1 ]; 
        then
            echo "Virt-manager is not installed, skipping configuring virt-manager"
        else
            echo "Configuring virt-manager"
            echo -e "\nunix_sock_group = \"libvirt\"\nunix_sock_rw_perms = \"0770\"" | sudo tee -a /etc/libvirt/libvirtd.conf
            sudo systemctl start libvirtd
            sudo systemctl enable libvirtd
            sudo usermod -a -G libvirt "$(whoami)"
            echo "Remember to re-login before using virt-manager"
        fi

        mkdir "$HOME"/.config/kitty/
        # Copy all of my config files to the config folder
        cp -r dotfiles/kitty/ ~/.config/kitty
        
        echo "Go to ~/.config/kitty/ to edit Kitty's config files"

        echo "Done configuring and install my daily apps"
        echo "Make sure to add /usr/bin to PATH variable and set DOCKER_HOST=unix:///run/user/1000/docker.sock"
        echo "For fish shell: open ~/.config/fish/config.fish, add \
        set -gx DOCKER_HOST \"unix:///run/user/1000/docker.sock\" below the \"if status is-interactive\" line"
        echo "And remember to add ~/flutter/bin to PATH to access Flutter's commands"
        
        break
    ;; 

    *) 
        echo "Aborted"
        break
    ;;
    esac
done

read -rp "Press any key to continue" _
