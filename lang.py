"""
fedora-post-install-script
Copyright (C) 2021 Hoàng Minh Thiên
This program comes with ABSOLUTELY NO WARRANTY
This is free software, and you are welcome to redistribute it
under certain conditions

Licensed under GPLv3 License
"""

CascadiaFontsInstallMSG = {
    "en": "Installing Cascadia Code Fonts and Powerline to make your Terminal better...",
    "vi": "Đang cài PowerLine và font Cascadia Code giúp Terminal đẹp hơn..."
}
getDraculaThemeMSG = {
    "en": "Installing Dracula theme...",
    "vi": "Đang tải Dracula theme giúp cho giao diện trông đẹp hơn..."
}
UpdateMSG = {
    "en": "Updating your system...",
    "vi": "Đang cập nhật hệ điều hành của bạn..."
}
DNFWriteMSG = {
    "en": "Optimizing DNF package manager config...",
    "vi": "Đang tối ưu hóa trình quản lý gói phần mềm DNF..."
}
EnableRPMFusionMSG = {
    "en": "Enabling RPM Fusion...",
    "vi": "Đang bật RPM Fusion để tải các phần mềm mã nguồn đóng/trả phí..."
}
EnableFlathubMSG = {
    "en": "Enabling Flathub...",
    "vi": "Đang bật Flathub để tải các phần mềm mã nguồn đóng/trả phí..."
}
CodecsInstallMSG = {
    "en": "Installing Multimedia codecs...",
    "vi": "Đang tải một số codec/thư viện cần thiết cho Multimedia..."
}
ToolsInstallMSG = {
    "en": "Installing some tools...",
    "vi": "Đang cài một số tool cần thiết..."
}

fontsInstallMSG = {
    "en": "Installing Google Noto Sans Fonts to make your GNOME Desktop prettier",
    "vi": "Đang cài font Noto Sans của Google để làm đẹp Desktop của bạn"
}
CoolBootModeMSG = {  # Just for fun
    "en": "Doing some magics that can help you become a cool guy :)",
    "vi": "Đang làm một bí thuật giúp bạn ngầu hơn khi xài Linux :)"
}
CleanUpMSG = {
    "en": "Cleaning up...",
    "vi": "Đang dọn một số tập tin tạm thời..."
}
BackUpMSG = {
    "en": "Backing up...",
    "vi": "Đang backup lại một số file phòng trường hợp máy bị lỗi..."
}
greeting = {
    "en": "Welcome to Fedora post-install script written by davidhoang05022009(Hoàng Minh Thiên)",
    "vi": "Chào mừng bạn đến với script post-install dành cho Fedora Linux viết bởi davidhoang05022009(Hoàng Minh Thiên)\n"
}
sudoReminder = {
    "en": "Hey, look like you didn't run the script with root/sudo permission. Re-run it by typing \'sudo python3 ./post-install.py\' in the Terminal",
    "vi": "Có vẻ bạn chưa chạy script với quyền root/sudo. Hãy hủy và khởi động lại chương trình bằng lệnh \'sudo python3 ./post-install.py\'"
}
acceptedMSG = {
    "en": "OK, let the script do its works, it won't take long...",
    "vi": "OK, hãy để script thực hiện công việc của mình, sẽ không lâu đâu..."
}
canceledMSG = {
    "en": "Aborted",
    "vi": "Đã hủy"
}
doneMSG = {
    "en": "Done, do you want to restart now?",
    "vi": "Xong, bạn có muốn khởi động lại máy không?"
}
doneWithoutRestartMSG = {
    "en": "OK, remember to restart your device",
    "vi": "Nhớ khởi động lại máy của bạn nhé ^^"
}
confirmation = {
    "en": "Continue?",
    "vi": "Bạn sẽ tiếp tục để script này chạy chứ?"
}
