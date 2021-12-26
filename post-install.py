import datetime
import os
from zipfile import ZipFile
from lang import *
import sys


def log(stage):
    print('[' + str(datetime.datetime.now()) + ']: ' + stage)


def getUserLanguage():
    lang = int(
        input("[1] Tiếng Việt/Vietnamese\n[2] Tiếng Anh/English\nEnter your choice: "))
    if lang == 1:
        return "vi"
    elif lang == 2:
        return "en"
    else:
        print("Invalid input, aborting...")
        sys.exit()


userLanguage = getUserLanguage()


def installPowerline():
    log(CascadiaFontsInstallMSG[userLanguage])

    os.system('sudo dnf install powerline -y')
    fRead = open('./.bashrc', 'r')
    os.system('echo \"' + fRead.read() + '\" >> ~/.bashrc')
    fRead.close()
    os.system('axel -n 20 https://github.com/microsoft/cascadia-code/releases/download/v2110.31/CascadiaCode-2110.31.zip')
    ZipFile('./CascadiaCode-2110.31.zip').extractall('./CascadiaCode-2110.31')
    os.system(
        'sudo mv ./CascadiaCode-2110.31/ttf/static/* /usr/share/fonts; fc-cache -f -v')
    os.system('source ~/.bashrc')
    # Set the terminal font
    os.system(
        'dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf')


def getDraculaTheme():
    log(getDraculaThemeMSG[userLanguage])
    os.system(
        'axel https://github.com/dracula/gtk/archive/master.zip -o gtk-master.zip')
    ZipFile('./gtk-master.zip', 'r').extractall('/usr/share/themes/')
    os.system('gsettings set org.gnome.desktop.interface gtk-theme \'gtk-master\'; gsettings set org.gnome.desktop.wm.preferences theme \'gtk-master\'')
    os.system(
        'gsettings set org.gnome.desktop.wm.preferences button-layout \":minimize,maximize,close\"')


def installFonts():
    log(fontsInstallMSG[userLanguage])
    os.system('sudo dnf install google-*-fonts -x *cjk* --skip-broken -y')
    os.system(
        'gsettings set org.gnome.desktop.interface font-name \'Noto Sans Medium 11\'')
    os.system(
        'gsettings set org.gnome.desktop.interface document-font-name \'Noto Sans Regular 11\'')
    os.system(
        'gsettings set org.gnome.desktop.interface monospace-font-name \'Cascadia Code PL 13\'')
    os.system(
        'gsettings set org.gnome.desktop.wm.preferences titlebar-font \'Noto Sans Bold 11\'')


def doUpdate():
    log(UpdateMSG[userLanguage])
    os.system('sudo dnf update -y')


def writeNewDNFConfig():
    log(DNFWriteMSG[userLanguage])
    os.system("sudo cp ./dnf.conf /etc/dnf/dnf.conf")


def enableRPMFusion():
    log(EnableRPMFusionMSG[userLanguage])
    os.system('sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y')
    os.system('sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y')


def enableFlathub():
    log(EnableFlathubMSG[userLanguage])
    os.system(
        'flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo')


def installCodecs():
    log(CodecsInstallMSG[userLanguage])
    os.system(
        'sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y')
    os.system('sudo dnf install lame\* --exclude=lame-devel -y')
    os.system('sudo dnf group upgrade --with-optional Multimedia -y')


def installTools():
    log(ToolsInstallMSG[userLanguage])
    os.system(
        'sudo dnf install htop neofetch xclip gedit axel git gnome-tweaks deltarpm -y')


def installIbusBamboo():  # only needed for Vietnamese
    log("Đang cài bộ gõ tiếng Việt ibus-bamboo để hỗ trợ các bạn gõ tiếng Việt")

    # check the version of Fedora
    fedora_version = 0
    os.system('rpm -E %fedora > fedora-version')
    fRead = open('./fedora-version', 'r')
    if int(fRead.read()) > 33:
        fedora_version = 33
    else:
        fedora_version = int(fRead.read())

    #install it and add it to input sources
    os.system('sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:lamlng/Fedora_' +
              fedora_version + '/home:lamlng.repo')
    os.system('sudo dnf install ibus-bamboo -y')
    os.system(
        'gsettings set org.gnome.desktop.input-sources sources [(\'xkb\', \'us\'), (\'ibus\', \'Bamboo::Us\')]')
    os.system('gsettings set org.gnome.desktop.interface gtk-im-module \'ibus\'')


def uninstallPlymouthAndEnableVerboseBootMode():
    log(CoolBootModeMSG[userLanguage])
    os.system("sudo cp ./grub /etc/default/grub")
    if os.path.exists('/sys/firmware/efi'):
        os.system('sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg')
    else:
        os.system('sudo grub2-mkconfig -o /boot/grub2/grub.cfg')
    os.system('sudo plymouth-set-default-theme details; sudo dracut -f')


def cleanUp():
    log(CleanUpMSG[userLanguage])
    os.system(
        'sudo rm -rf ./CascadiaCode-* ./gtk-master.zip')


def backUp():
    log(BackUpMSG[userLanguage])
    os.system("sudo cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bak")
    os.system("sudo cp ~/.bashrc ~/.bashrc.bak")
    os.system("sudo cp /etc/default/grub /etc/default/grub.bak")


print("fedora-post-install-script\nCopyright (C) 2021 Hoàng Minh Thiên\nThis program comes with ABSOLUTELY NO WARRANTY\nThis is free software, and you are welcome to redistribute it\nunder certain conditions")
print(greeting[userLanguage])
print(sudoReminder[userLanguage])
confirm = input(confirmation[userLanguage] + ' [y(es)/n(o)]: ')
if confirm.lower() == 'y' or confirm.lower() == 'yes':
    print(acceptedMSG[userLanguage])
    cleanUp()
    backUp()
    writeNewDNFConfig()
    doUpdate()
    installTools()
    enableRPMFusion()
    enableFlathub()
    installCodecs()
    uninstallPlymouthAndEnableVerboseBootMode()
    getDraculaTheme()
    installPowerline()
    installFonts()
    if userLanguage == 'vi':
        installIbusBamboo()
    cleanUp()
    confirm2 = input(
        doneMSG[userLanguage] + ' [y(es)/n(o)]: ')
    if confirm2.lower() == 'y' or confirm2.lower() == 'yes':
        os.system('sudo systemctl reboot')
    else:
        print(doneWithoutRestartMSG[userLanguage])
else:
    print(canceledMSG[userLanguage])
