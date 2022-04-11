#! /bin/bash
# ./scripts/installTools.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

echo -e "The script will install the following packages: \n\nhtop \nneofetch \nxclip \ngnome-tweaks \nmicro \ncode (Visual Studio Code) \ngh-cli \nGithubDesktop-linux-2.9.9-linux2 (Not in Fedora repos)\n"
while true; do
    read -rp "Continue? [y/N]: " yn
    case $yn in
    [Yy]*) 
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
        sudo dnf update
        axel -n 20 https://github.com/shiftkey/desktop/releases/download/release-2.9.9-linux2/GitHubDesktop-linux-2.9.9-linux2.rpm
        sudo dnf install htop neofetch xclip gnome-tweaks micro code gh ./GitHubDesktop-linux-2.9.9-linux2.rpm kitty -
        mkdir "$HOME"/.config/kitty/
        
        # These files i grabbed from Dracula (again xD)
        cp dotfiles/kitty/diff.conf ~/.config/kitty/
        cp dotfiles/kitty/dracula.conf ~/.config/kitty/
        
        # This is my personal Kitty config file
        cp dotfiles/kitty/kitty.conf ~/.config/kitty/
        
        echo "Go to ~/.config/kitty/ to edit Kitty's config files"
        notify-send "Installed tools"
        break
    ;; 

    *) 
        echo "Aborted"
        break
    ;;
    esac
done
read -rp "Press any key to continue" _