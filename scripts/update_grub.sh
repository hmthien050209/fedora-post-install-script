#! /bin/bash
# ./scripts/update_grub.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

if [ -f "/sys/firmware/efi" ]; 
then
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
else
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
fi