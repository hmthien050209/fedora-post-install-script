import datetime
import os
from zipfile import ZipFile


def log(stage):
    print('[' + str(datetime.datetime.now()) + ']: ' + stage)


def installPowerline():
    log('Đang cài PowerLine và font Cascadia Code giúp Terminal đẹp hơn...')
    os.system('sudo dnf install powerline -y')
    fRead = open('./.bashrc', 'r')
    fo = open(str(os.path.expanduser('~'))+'/.bashrc', 'w')
    fo.write(fRead.read())
    fo.flush()
    fo.close()
    fRead.close()
    os.system('axel -n 20 https://github.com/microsoft/cascadia-code/releases/download/v2110.31/CascadiaCode-2110.31.zip')
    ZipFile('./CascadiaCode-2110.31.zip').extractall('./')
    os.system(
        'sudo mv ./CascadiaCode-2110.31/ttf/static/* /usr/share/fonts && fc-cache -f -v')


def getDraculaTheme():
    log('Đang tải Dracula theme giúp cho giao diện trông đẹp hơn')
    os.system('axel -n 20 https://github.com/dracula/gtk/archive/master.zip')
    ZipFile('./gtk-master.zip', 'r') .extractall('/usr/share/themes/')
    os.system('gsettings set org.gnome.desktop.interface gtk-theme \"Dracula\" && gsettings set org.gnome.desktop.wm.preferences theme \"Dracula\"')
    os.system(
        'gsettings set org.gnome.desktop.wm.preferences button-layout \'close,minimize,maximize:\'')


def doUpdateAndUpgrade():
    log('Đang cập nhật hệ thống...')
    os.system('sudo dnf update -y && sudo dnf upgrade -y')


def writeNewDNFConfig():
    log('Đang tối ưu hóa trình quản lý gói phần mềm DNF...')
    fRead = open('./dnf.conf', 'r')
    fo = open('/etc/dnf/dnf.conf', 'w')
    fo.write(fRead.read())
    fo.flush()
    fo.close()
    fRead.close()


def enableRPMFusion():
    log('Đang bật RPM Fusion để tải các phần mềm mã nguồn đóng/trả phí...')
    os.system('sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y')
    os.system('sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y')


def enableFlathub():
    log('Đang bật Flathub để tải các phần mềm mã nguồn đóng/trả phí...')
    os.system(
        'flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo')


def enableSnapd():
    log('Đang bật snapd để tải các phần mềm mã nguồn đóng/trả phí...')
    os.system('sudo dnf install snapd -y')


def installCodecs():
    log('Đang tải một số codec/thư viện cần thiết cho Multimedia...')
    os.system(
        'sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y')
    os.system('sudo dnf install lame\* --exclude=lame-devel -y')
    os.system('sudo dnf group upgrade --with-optional Multimedia -y')


def installSoftware():
    log('Đang cài một số tool cần thiết...')
    os.system('sudo dnf install htop neofetch xclip gedit axel git gnome-tweaks -y')


def uninstallPlymouthAndEnableVerboseBootMode():
    # Thật ra hàm này tắt giao diện khởi động chỉ để cho ngầu :))
    log('Đang làm một bí thuật giúp bạn ngầu hơn khi xài Linux :))')
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
    log('Đang dọn một số tập tin tạm thời...')
    os.system('rm -rf ./CascadiaCode-2110.31 ./gtk-master.zip')


def backUp():
    log('Đang backup lại một số file phòng trường hợp máy bị lỗi...')

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
    fReadgrub = open('/etc/default/grub', 'r')
    fWritegrubBackup = open('./grub.bak', 'x')
    fWritegrubBackup.write(fReadgrub.read())
    fWritegrubBackup.flush()
    fWritegrubBackup.close()
    fReadgrub.close()
    log("Đã backup xong...")


print('Chào mừng bạn đến với script init Fedora Linux viết bởi davidhoang05022009(Hoàng Minh Thiên)\n')
print('Bạn cần chạy lệnh này dưới quyền root. Nếu không biết bạn đã ở quyền root hay chưa, hãy hủy và khởi động lại chương trình bằng lệnh \'sudo python3 -m post-install\'')
print('Nếu đây là lần đầu bạn tiếp xúc với Linux thì script này sẽ giúp bạn cài đặt những thứ cần thiết để sử dụng trong việc học tập và làm việc hàng ngày\n')
confirm = input('Bạn sẽ tiếp tục để script này chạy chứ? [y(es)/n(o)]: ')
if confirm.lower() == 'y' or confirm.lower() == 'yes':
    print('Bạn hãy đợi 10 phút để phần mềm làm việc cho bạn, phần mềm cần mật khẩu để chình sửa một vài thông tin hệ thống, nên bạn yên tâm nhập vào nha ^^')
    print('\nHãy đi pha 1 tách cà phê và chờ/đi tập thể dục...')
    backUp()
    doUpdateAndUpgrade()
    writeNewDNFConfig()
    installSoftware()
    enableRPMFusion()
    enableFlathub()
    enableSnapd()
    installCodecs()
    uninstallPlymouthAndEnableVerboseBootMode()
    getDraculaTheme()
    installPowerline()
    cleanUp()
    print('Đã hoàn thành...')
    confirm2 = input(
        'Bạn có muốn khởi động lại máy ngay bây giờ không? [y(es)/n(o)]: ')
    if confirm2.lower() == 'y' or confirm2.lower() == 'yes':
        os.system('sudo systemctl reboot')
    else:
        print('Nhiệm vụ của script đã hoàn tất, chỉ cần khới động lại là xong việc...')
else:
    print('Đã hủy lệnh...')
