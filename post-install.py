import datetime
import os

def log(stage):
    print("[" + str(datetime.datetime.now()) + "]: " + stage)


def doUpdateAndUpgrade():
    log("Đang cập nhật hệ thống...")
    os.system("sudo dnf update -y && sudo dnf upgrade -y")


def writeNewDNFConfig():
    log("Đang tối ưu hóa trình quản lý gói phần mềm DNF...")
    fo = open("/etc/dnf/dnf.conf", "w")
    fo.write("[main]\ngpgcheck=1\ninstallonly_limit=3\nclean_requirements_on_remove=True\nbest=False\nskip_if_unavailable=True\nfastestmirror=True\nmax_parallel_downloads=20\ndefaultyes=True")
    fo.flush()
    fo.close()


def enableRPMFusion():
    log("Đang bật RPM Fusion để tải các phần mềm mã nguồn đóng/trả phí...")
    os.system("sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y")
    os.system("sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y")


def enableFlathub():
    log("Đang bật Flathub để tải các phần mềm mã nguồn đóng/trả phí...")
    os.system(
        "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo")


def enableSnapd():
    log("Đang bật snapd để tải các phần mềm mã nguồn đóng/trả phí...")
    os.system("sudo dnf install snapd -y")


def installCodecs():
    log("Đang tải một số codec/thư viện cần thiết cho Multimedia...")
    os.system(
        "sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y")
    os.system("sudo dnf install lame\* --exclude=lame-devel -y")
    os.system("sudo dnf group upgrade --with-optional Multimedia -y")


def installSoftware():
    log("Đang cài một số tool cần thiết...")
    os.system("sudo dnf install htop neofetch xclip gedit -y")


def uninstallPlymouthAndEnableVerboseBootMode():
    # Thật ra hàm này tắt giao diện khởi động chỉ để cho ngầu :))
    log("Đang làm một bí thuật giúp bạn ngầu hơn khi xài Linux :))")
    fo = open("/etc/default/grub", "w")
    fo.write("GRUB_TIMEOUT=5\nGRUB_DISTRIBUTOR=\"$(sed 's, release .*$,,g' /etc/system-release)\"\nGRUB_DEFAULT=saved\nGRUB_DISABLE_SUBMENU=true\nGRUB_TERMINAL_OUTPUT=\"console\"\nGRUB_CMDLINE_LINUX=\"\"\nGRUB_DISABLE_RECOVERY=\"true\"\nGRUB_ENABLE_BLSCFG=true")
    fo.flush()
    fo.close()
    if os.path.exists("/sys/firmware/efi"):
        os.system("sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg")
    else:
        os.system("sudo grub2-mkconfig -o /boot/grub2/grub.cfg")
    os.system("sudo plymouth-set-default-theme details && sudo dracut -f")

print("Chào mừng bạn đến với script init Fedora Linux viết bởi davidhoang05022009(Hoàng Minh Thiên)\n")
print("Bạn cần chạy lệnh này dưới quyền root. Nếu không biết bạn đã ở quyền root hay chưa, hãy hủy và khởi động lại chương trình bằng lệnh \'sudo python3 -m post-install.py\'")
print("Nếu đây là lần đầu bạn tiếp xúc với Linux thì script này sẽ giúp bạn cài đặt những thứ cần thiết để sử dụng trong việc học tập và làm việc hàng ngày\n")
confirm = input("Bạn sẽ tiếp tục để script này chạy chứ? [y(es)/n(o)]: ")
if confirm == "y" or confirm == "Y" or confirm.lower() == "yes":
    print("Bạn hãy đợi 10 phút để phần mềm làm việc cho bạn, phần mềm cần mật khẩu để chình sửa một vài thông tin hệ thống, nên bạn yên tâm nhập vào nha ^^")
    print("\nHãy đi pha 1 tách cà phê và chờ/đi tập thể dục...")
    doUpdateAndUpgrade()
    writeNewDNFConfig()
    enableRPMFusion()
    enableFlathub()
    enableSnapd()
    installCodecs()
    installSoftware()
    uninstallPlymouthAndEnableVerboseBootMode()
    print("Đã hoàn thành...")
    confirm2 = input("Bạn có muốn khởi động lại máy ngay bây giờ không? [y(es)/n(o)]: ")
    if confirm2 == "y" or confirm2 == "Y" or confirm2.lower() == "yes":
        os.system("sudo systemctl reboot")
    else:
        print("Nhiệm vụ của script đã hoàn tất, chỉ cần khới động lại là xong việc...")
else:
    print("Đã hủy lệnh...")