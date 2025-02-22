#!/bin/sh
# Remove the kernel source files on the NVIDIA Jetson TK1
if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   echo "$ sudo "$0""
   exit
fi

# Remove the kernel sources and build entrails
sudo rm -r /usr/src/gtest
sudo rm -r /usr/src/Linux_for_Tegra
sudo rm    /usr/src/public_sources.tbz2


