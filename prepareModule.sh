#!/bin/sh
# Prepare to build the RTC DS3232 module  for LT4 35.1 on the NVIDIA Jetson AGX Xavier
if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   echo "$ sudo "$0""
   exit
fi
# Get the kernel source for LT4 35.1
cd /usr/src/
wget https://developer.nvidia.com/embedded/l4t/r35_release_v1.0/sources/public_sources.tbz2
tar -xvf public_sources.tbz2
cd Linux_for_Tegra/source/public/
# Decompress
tar -xvf kernel_src.tbz2
cd kernel/kernel-5.10/
# Get the kernel configuration file
zcat /proc/config.gz > .config
# Enable DS3232 compilation; it should be the same as a DS1307
sudo sed -i 's/# CONFIG_RTC_DRV_DS1307 is not set/CONFIG_RTC_DRV_DS1307=m/' .config
# Make sure that the local kernel version is set
LOCALVERSION=$(uname -r)
# vodoo incantation; This removes everything from the beginning to the last occurrence of "-"
# of the local version string i.e. 3.10.40 is removed
release="${LOCALVERSION##*-}"
CONFIGVERSION="CONFIG_LOCALVERSION=\"-$release\""
# Replace the empty local version with the local version of this kernel
sudo sed -i 's/CONFIG_LOCALVERSION=""/'$CONFIGVERSION'/' .config
# Prepare the module for compilation
make prepare
make modules_prepare
# Compile the module
make M=drivers/rtc/
# After compilation, copy the compiled module to the system area
cp drivers/rtc/rtc-ds1307.ko /lib/modules/$(uname -r)/kernel
depmod -a
/bin/echo -e "\e[1;32mReal Time Clock (DS1307, DS3231) Driver Module Installed.\e[0m"

