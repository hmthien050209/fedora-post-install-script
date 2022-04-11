#! /bin/bash
# ./scripts/optimizeBootTime.sh
# SPDX-License-Identifier: GPL-3.0-or-later

# fedora-post-install-script
# Copyright (C) 2022 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions
#
# Licensed under GPLv3 License

echo "Optimizing boot time for your PC/laptop"
echo "Checking if your CPU is Intel's CPU or not"
if [ "$(< /proc/cpuinfo grep "GenuineIntel" | head -1 | cut -d "e" -f 4-)" == "Intel" ]; 
then 
    echo "Your CPU is Intel's CPU, let's optimize it"
    lscpu | grep -i "Model name"
    echo -e "\nGRUB_CMDLINE_LINUX_DEFAULT=\"intel_idle.max_cstate=1 cryptomgr.notests initcall_debug intel_iommu=igfx_off no_timer_check noreplace-smp page_alloc.shuffle=1 rcupdate.rcu_expedited=1 tsc=reliable quiet splash video=SVIDEO-1:d\"" | sudo tee -a /etc/default/grub # This is from Clear Linux, my friends found out this and suggested me
    scripts/update_grub.sh
    sudo systemctl disable NetworkManager-wait-online.service # This one take the longest time while booting on my laptop
else
    echo "Your CPU is not Intel's CPU, doing some basic optimization"
    sudo systemctl disable NetworkManager-wait-online.service # This one take the longest time while booting on my laptop
fi
echo -e "If you're using a SSD with btrfs, you should optimize it by following this guide\nhttps://mutschler.eu/linux/install-guides/fedora-post-install/#btrfs-filesystem-optimizations"
notify-send "Disabled quiet boot screen and optimized booting time for your PC/laptop"
read -rp "Press any key to continue" _