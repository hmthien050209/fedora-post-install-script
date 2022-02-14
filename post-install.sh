#! /bin/bash
# ./post-install.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2021 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

HEIGHT=25
WIDTH=90
CHOICE_HEIGHT=4
BACKTITLE="Fedora post-install script by davidhoang05022009 (Hoàng Minh Thiên)"
MENU_MSG="Please select one of following options:"

# URLs variables
CASCADIA_CODE_URL="https://github.com/microsoft/cascadia-code/releases/download/v2110.31/CascadiaCode-2110.31.zip"

# First, optimize the dnf package manager
sudo cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bak
sudo cp ./dnf.conf /etc/dnf/dnf.conf
sudo dnf upgrade --refresh -y

# Check for updates
sudo dnf check
sudo dnf autoremove -y
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update -y

function update_grub() {
    if [ -f "/sys/firmware/efi" ]; 
    then
        sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    else
        sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
}

# Install some tools required by the script
sudo dnf install axel deltarpm unzip -y

# Check if we have dialog installed
# If not, install it
if [ "$(rpm -q dialog 2>/dev/null | grep -c "is not installed")" -eq 1 ]; 
then
    sudo dnf install -y dialog
fi

OPTIONS=(
    1  "Install tools - Read more in README.md"
    2  "Enable RPM Fusion"
    3  "Enable Flathub"
    4  "Install media codecs - Read more in README.md"
    5  "Plymouth options ->"
    6  "Optimize booting time" 
    7  "Install auto-cpufreq (recommended for laptop users)"
    8  "Install Google Noto Sans fonts, Microsoft Cascadia Code fonts"
    9  "Install Starship (a cross-shell prompt)"
    10 "Install Dracula theme"
    11 "Recover maximize, minimize button"
    12 "Install Pop Shell for tiling window on GNOME"
    13 "Install ibus-bamboo (\"Bộ gõ tiếng Việt\" for Vietnamese users)"
    14 "Enable dnf-automatic (Automatic updates)"
    15 "Secure your Linux system (by Chris Titus Tech)"
    16 "Install my daily apps"
    17 "Reboot"
    18 "Quit"
)

PLYMOUTH_OPTIONS=(
    1  "Disable quiet boot screen"
    2  "Just display vendor logo at boot (disable plymouth)"
    3  "Go back to main menu"
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
        1) echo "Installing tools"
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
        sudo dnf update -y
        axel -n 20 https://github.com/shiftkey/desktop/releases/download/release-2.9.6-linux1/GitHubDesktop-linux-2.9.6-linux1.rpm
        sudo dnf install htop neofetch xclip gnome-tweaks micro code gh ./GitHubDesktop-linux-2.9.6-linux1.rpm -y

        # Check if the Cascadia Code fonts exists for Kitty
        if [ "$(fc-list | grep -c 'Cascadia Code')" -lt 1 ];
        then
            while true; do
                echo "Seems like Microsoft Cascadia Code fonts (required by my Kitty config file) are not installed."
                read -rp "Do you want to install it? [y/n] (Select 'n' if you want to edit the config files for other fonts): " yn
                case $yn in
                    [Yy]*) echo "Installing Microsoft Cascadia Code fonts" 
                    axel -n 20 $CASCADIA_CODE_URL
                    unzip ./CascadiaCode-2110.31.zip -d ./CascadiaCode-2110.31
                    sudo mv ./CascadiaCode-2110.31/ttf/static/* /usr/share/fonts
                    fc-cache -f -v
                    break
                    ;;  

                    [Nn]*) echo "Okie, continuing install Kitty" 
                    break
                    ;;
                esac
            done
        fi

        sudo dnf install kitty -y
        
        # These files i grabbed from Dracula (again xD)
        cp -r ./diff.conf ~/.config/kitty/
        cp -r ./dracula.conf ~/.config/kitty/
        
        # This is my personal Kitty config file
        cp -r ./kitty.conf ~/.config/kitty/
        
        echo "Go to ~/.config/kitty/ to edit Kitty's config files"
        notify-send "Installed tools"
        read -rp "Press any key to continue" _
        ;;
        
        2) echo "Enabling RPM Fusion"
        sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y
        sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y
        sudo dnf upgrade --refresh -y
        sudo dnf groupupdate core -y
        sudo dnf install rpmfusion-free-release-tainted -y
        sudo dnf install dnf-plugins-core -y
        notify-send "Enabled RPM Fusion"
        read -rp "Press any key to continue" _
        ;;
        
        3) echo "Enabling Flathub"
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        notify-send "Enabled Flathub"
        read -rp "Press any key to continue" _
        ;;

        4) echo "Installing media codecs"
        sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
        sudo dnf install lame\* --exclude=lame-devel -y
        sudo dnf group upgrade --with-optional Multimedia -y
        notify-send "Installed media codecs"
        read -rp "Press any key to continue" _
        ;;

        5) 
        while true; do
            PLYMOUTH_CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE - Plymouth options menu $(lscpu | grep -i "Model name:" | cut -d':' -f2- - )" \
                --title "$TITLE" \
                --nocancel \
                --menu "$MENU_MSG" \
                11 $WIDTH $CHOICE_HEIGHT \
                "${PLYMOUTH_OPTIONS[@]}" \
                2>&1 >/dev/tty)
            clear
            case $PLYMOUTH_CHOICE in
                1) echo "Disabling quiet boot screen"
                while true; do
                    read -rp "Do you want to install grub themes in the future? [y/n] (Select 'n' if you won't install grub themes in the future): " yn
                    case $yn in
                    [Yy]*) 
                    sudo cp /etc/default/grub /etc/default/grub.bak
                    sudo cp ./grub-quiet-theme-compatible /etc/default/grub
                    break
                    ;;  

                    [Nn]*) 
                    sudo cp /etc/default/grub /etc/default/grub.bak
                    sudo cp ./grub-quiet /etc/default/grub 
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
                    read -rp "Do you want to install grub themes in the future? [y/n] (Select 'n' if you won't install grub themes in the future): " yn
                    case $yn in
                    [Yy]*) 
                    sudo cp /etc/default/grub /etc/default/grub.bak
                    sudo cp ./grub-plymouth-disable-theme-compatible /etc/default/grub
                    break
                    ;;  

                    [Nn]*) 
                    sudo cp /etc/default/grub /etc/default/grub.bak
                    sudo cp ./grub-plymouth-disable /etc/default/grub 
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
        ;;

        6) echo "Optimizing boot time for your PC/laptop"
        echo "Checking if your CPU is Intel's CPU or not"
        if [ "$(< /proc/cpuinfo grep "GenuineIntel" | head -1 | cut -d "e" -f 4-)" == "Intel" ]; 
        then 
            echo "Your CPU is Intel's CPU, let's optimize it"
            lscpu | grep -i "Model name"
            echo -e "\nGRUB_CMDLINE_LINUX_DEFAULT=\"intel_idle.max_cstate=1 cryptomgr.notests initcall_debug intel_iommu=igfx_off no_timer_check noreplace-smp page_alloc.shuffle=1 rcupdate.rcu_expedited=1 tsc=reliable quiet splash video=SVIDEO-1:d\"" | sudo tee -a /etc/default/grub # This is from Clear Linux, my friends found out this and suggested me
            update_grub
            sudo systemctl disable NetworkManager-wait-online.service # This one take the longest time while booting on my laptop
        else
            echo "Your CPU is not Intel's CPU, doing some basic optimization"
            sudo systemctl disable NetworkManager-wait-online.service # This one take the longest time while booting on my laptop
        fi
        echo -e "If you're using a SSD with btrfs, you should optimize it by following this guide\nhttps://mutschler.eu/linux/install-guides/fedora-post-install/#btrfs-filesystem-optimizations"
        notify-send "Disabled quiet boot screen and optimized booting time for your PC/laptop"
        read -rp "Press any key to continue" _
        ;;

        7) echo "Installing auto-cpufreq"
        echo -e "Please select the \"i\" option to install when the installer prompts"
        # You can see the official install guide here 
        # https://github.com/AdnanHodzic/auto-cpufreq/#auto-cpufreq-installer
        git clone https://github.com/AdnanHodzic/auto-cpufreq.git
        chmod +x ./auto-cpufreq/auto-cpufreq-installer
        sudo ./auto-cpufreq/auto-cpufreq-installer
        sudo auto-cpufreq --install
        notify-send "Installed auto-cpufreq"
        read -rp "Press any key to continue" _
        ;;

        8) echo "Installing Google Noto Sans fonts, Microsoft Cascadia Code fonts and apply it to system fonts"
        sudo dnf install google-noto-sans-fonts -y
        axel -n 20 $CASCADIA_CODE_URL
        unzip ./CascadiaCode-2110.31.zip -d ./CascadiaCode-2110.31
        sudo mv ./CascadiaCode-2110.31/ttf/static/* /usr/share/fonts
        fc-cache -f -v
        gsettings set org.gnome.desktop.interface font-name 'Noto Sans Medium 11'
        gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans Regular 11'
        gsettings set org.gnome.desktop.interface monospace-font-name 'Cascadia Code PL 13'
        gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Noto Sans Bold 11'
        notify-send "Installed Google Noto Sans fonts, Microsoft Cascadia Code fonts and applied it to system fonts"
        read -rp "Press any key to continue" _
        ;;

        9) echo "Installing Starship"
        # Check if the Cascadia Code fonts exists for this
        if [ "$(fc-list | grep -c 'Cascadia Code')" -lt 1 ];
        then
            while true; do
                echo "Seems like Microsoft Cascadia Code fonts (required by Starship) are not installed."
                read -rp "Do you want to install it? [y/n] (Select 'n' if you have other Starship-compatible/Nerd fonts installed): " yn
                case $yn in
                    [Yy]*) echo "Installing Microsoft Cascadia Code fonts" 
                    axel -n 20 $CASCADIA_CODE_URL
                    unzip ./CascadiaCode-2110.31.zip -d ./CascadiaCode-2110.31
                    sudo mv ./CascadiaCode-2110.31/ttf/static/* /usr/share/fonts
                    fc-cache -f -v
                    break
                    ;;  

                    [Nn]*) echo "Okie, continuing install Starship" 
                    break
                    ;;
                esac
            done
        fi
        cp ~/.bashrc ~/.bashrc.bak
        sudo dnf install starship -y
        echo -e "eval \"$(starship init bash)\"" | tee -a ~/.bashrc
        # shellcheck disable=SC1090
        # OK I am using ShellCheck, it's fine to specify the ~/ here
        source ~/.bashrc
        notify-send "Installed Starship"
        read -rp "Press any key to continue" _
        ;;

        10) echo "Installing Dracula theme"
        sudo git clone https://github.com/dracula/gtk.git /usr/share/themes/Dracula
        gsettings set org.gnome.desktop.interface gtk-theme 'Dracula' 
        gsettings set org.gnome.desktop.wm.preferences theme 'Dracula'
        axel -n 20 https://github.com/dracula/wallpaper/blob/master/fedora.png
        gsettings set org.gnome.desktop.screensaver picture-uri "file:///$(pwd)/fedora.png"
        gsettings set org.gnome.desktop.screensaver primary-color "#000000000000"
        gsettings set org.gnome.desktop.screensaver secondary-color "#000000000000"
        notify-send "Installed Dracula theme"
        read -rp "Press any key to continue" _
        ;;

        11) echo "Recovering maximize, minimize button"
        gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
        notify-send "Recovered maximiaze, minimize button"
        read -rp "Press any key to continue" _
        ;;

        12) echo "Installing Pop Shell"
        sudo dnf install gnome-shell-extension-pop-shell xprop -y
        echo "Enabling Pop Shell"
        gnome-extensions enable pop-shell@system76.com # may need to go to extensions to enable
        gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true
        gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba "rgb(66,103,212)"
        gsettings set org.gnome.shell.extensions.pop-shell gap-outer 0
        gsettings set org.gnome.shell.extensions.pop-shell gap-inner 0
        notify-send "Installed and enabled Pop Shell, if Pop Shell is not enabled, go to Extensions to enable it"
        read -rp "Press any key to continue" _
        ;;
        
        13) echo "Installing ibus-bamboo"
        if [ "$(rpm -E %fedora)" -gt 33 ];
        then
            sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:lamlng/Fedora_33/home:lamlng.repo
        else
            sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:lamlng/Fedora_"$(rpm -E %fedora)"/home:lamlng.repo
        fi
        sudo dnf install ibus-bamboo -y
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo::Us')]"
        gsettings set org.gnome.desktop.interface gtk-im-module 'ibus'
        notify-send "Installed ibus-bamboo"
        read -rp "Press any key to continue" _
        ;;
        
        14) echo "Enabling dnf-automatic(Automatic updates)"
        sudo dnf install dnf-automatic -y
        sudo cp ./automatic.conf /etc/dnf/automatic.conf
        sudo systemctl enable --now dnf-automatic.timer
        notify-send "Enabled dnf-automatic"
        read -rp "Press any key to continue" _
        ;;

        15) echo "Enhancing your Linux system's security"
        sudo dnf install ufw fail2ban -y
        sudo systemctl enable --now ufw.service
        sudo systemctl disable --now firewalld.service
        git clone https://github.com/ChrisTitusTech/secure-linux
        chmod +x ./secure-linux/secure.sh
        sudo ./secure-linux/secure.sh
        notify-send "Enhanced your Linux system's security"
        read -rp "Press any key to continue" _
        ;;

        16) echo "Installing my daily apps"
        echo -e "[anydesk]\nname=AnyDesk Fedora - stable\nbaseurl=http://rpm.anydesk.com/fedora/\$basearch/\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY" | sudo tee /etc/yum.repos.d/AnyDesk-Fedora.repo
        sudo dnf --releasever=32 install pangox-compat.x86_64
        sudo dnf makecache
        sudo dnf install redhat-lsb-core anydesk -y
        sudo dnf install google-chrome vlc obs-studio @virtualization shotcut ulauncher seahorse clang cmake ninja-build pkg-config gtk3-devel xz-devel variety -y
        flatpak install flathub com.discordapp.Discord -y
        curl -O https://raw.githubusercontent.com/bb010g/betterdiscordctl/master/betterdiscordctl
        chmod +x betterdiscordctl
        mv betterdiscordctl /usr/local/bin
        betterdiscordctl --d-install flatpak install
        curl https://raw.githubusercontent.com/dracula/betterdiscord/master/Dracula.theme.css -o ~/.var/app/com.discordapp.Discord/config/BetterDiscord/themes/Dracula.theme.css
        flatpak install flathub org.signal.Signal -y
        flatpak install flathub org.telegram.desktop -y
        flatpak install flathub org.remmina.Remmina -y
        flatpak install flathub org.geogebra.GeoGebra -y
        flatpak install com.bitwarden.desktop -y
        echo "Configuring virt-manager"
        echo -e "\nunix_sock_group = \"libvirt\"\nunix_sock_rw_perms = \"0770\""
        sudo systemctl start libvirtd
        sudo systemctl enable libvirtd
        sudo usermod -a -G libvirt "$(whoami)"
        echo "Done configuring and install my daily apps, make sure to re-login before using virt-manager"
        read -rp "Press any key to continue" _
        ;;
        
        17)
        sudo systemctl reboot
        ;;

        18) rm -rf CascadiaCode*
        exit 0
        ;;

    esac
done
