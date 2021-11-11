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
    fo = open(str(os.path.expanduser('~'))+'/.bashrc', 'a')
    fo.write(fRead.read())
    fo.flush()
    fo.close()
    fRead.close()
    os.system('axel -n 20 https://github.com/microsoft/cascadia-code/releases/download/v2110.31/CascadiaCode-2110.31.zip')
    ZipFile('./CascadiaCode-2110.31.zip').extractall('./CascadiaCode-2110.31')
    os.system(
        'sudo mv ./CascadiaCode-2110.31/ttf/static/* /usr/share/fonts && fc-cache -f -v')
    os.system('source ~/.bashrc')
    #set the terminal font
    os.system('gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font --type=boolean false; gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string \"Cascadia Code PL\"')


def getDraculaTheme():
    log(getDraculaThemeMSG[userLanguage])
    os.system(
        'axel https://github.com/dracula/gtk/archive/master.zip -o gtk-master.zip')
    ZipFile('./gtk-master.zip', 'r') .extractall('/usr/share/themes/')
    os.system('gsettings set org.gnome.desktop.interface gtk-theme \'gtk-master\' && gsettings set org.gnome.desktop.wm.preferences theme \'gtk-master\'')
    os.system(
        'gsettings set org.gnome.desktop.wm.preferences button-layout \":minimize,maximize,close\"')


def doUpdateAndUpgrade():
    log(UpdateMSG[userLanguage])
    os.system('sudo dnf update -y && sudo dnf upgrade -y')


def writeNewDNFConfig():
    log(DNFWriteMSG[userLanguage])
    fRead = open('./dnf.conf', 'r')
    fo = open('/etc/dnf/dnf.conf', 'w')
    fo.write(fRead.read())
    fo.flush()
    fo.close()
    fRead.close()


def enableRPMFusion():
    log(EnableRPMFusionMSG[userLanguage])
    os.system('sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y')
    os.system('sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y')


def enableFlathub():
    log(EnableFlathubMSG[userLanguage])
    os.system(
        'flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo')


def enableSnapd():
    log(EnableSnapdMSG[userLanguage])
    os.system('sudo dnf install snapd -y')


def installCodecs():
    log(CodecsInstallMSG[userLanguage])
    os.system(
        'sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y')
    os.system('sudo dnf install lame\* --exclude=lame-devel -y')
    os.system('sudo dnf group upgrade --with-optional Multimedia -y')


def installTools():
    log(ToolsInstallMSG[userLanguage])
    os.system(
        'sudo dnf install htop neofetch xclip gedit axel git gnome-tweaks GConf2 -y')


def uninstallPlymouthAndEnableVerboseBootMode():
    log(CoolBootModeMSG[userLanguage])
    fRead = open('./grub', 'r')
    fo = open('/etc/default/grub', 'w')
    fo.write(fRead.read())
    fo.flush()
    fo.close()
    if os.path.exists('/sys/firmware/efi'):
        os.system('sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg')
    else:
        os.system('sudo grub2-mkconfig -o /boot/grub2/grub.cfg')
    os.system('sudo plymouth-set-default-theme details && sudo dracut -f')


def cleanUp():
    log(CleanUpMSG[userLanguage])
    os.system(
        'sudo rm -rf ./CascadiaCode-2110.31 ./CascadiaCode-2110.31.zip ./gtk-master.zip ./grub.bak ./dnf.conf.bak ./.bashrc.bak')


def backUp():
    log(BackUpMSG[userLanguage])

    #Backup dnf.conf
    fReadDNFConf = open('/etc/dnf/dnf.conf', 'r')
    fWriteDNFConfBackup = open('./dnf.conf.bak', 'x')
    fWriteDNFConfBackup.write(fReadDNFConf.read())
    fWriteDNFConfBackup.flush()
    fWriteDNFConfBackup.close()
    fReadDNFConf.close()

    #Backup .bashrc
    fReadBASHRC = open(str(os.path.expanduser('~'))+'/.bashrc', 'r')
    fWriteBASHRCBackup = open('./.bashrc.bak', 'x')
    fWriteBASHRCBackup.write(fReadBASHRC.read())
    fWriteBASHRCBackup.flush()
    fWriteBASHRCBackup.close()
    fReadBASHRC.close()

    #Backup grub
    #Backup .bashrc
    fReadgrub = open('/etc/default/grub', 'r')
    fWritegrubBackup = open('./grub.bak', 'x')
    fWritegrubBackup.write(fReadgrub.read())
    fWritegrubBackup.flush()
    fWritegrubBackup.close()
    fReadgrub.close()


print(greeting[userLanguage])
print(sudoReminder[userLanguage])
confirm = input(confirmation[userLanguage] + ' [y(es)/n(o)]: ')
if confirm.lower() == 'y' or confirm.lower() == 'yes':
    print(acceptedMSG[userLanguage])
    cleanUp()
    backUp()
    doUpdateAndUpgrade()
    writeNewDNFConfig()
    installTools()
    enableRPMFusion()
    enableFlathub()
    enableSnapd()
    installCodecs()
    uninstallPlymouthAndEnableVerboseBootMode()
    getDraculaTheme()
    installPowerline()
    cleanUp()
    confirm2 = input(
        doneMSG[userLanguage] + ' [y(es)/n(o)]: ')
    if confirm2.lower() == 'y' or confirm2.lower() == 'yes':
        os.system('sudo systemctl reboot')
    else:
        print(doneWithoutRestartMSG[userLanguage])
else:
    print(canceledMSG[userLanguage])