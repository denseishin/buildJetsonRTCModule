# buildJetsonRTCModule
Script for building a RTC Module for the Dallas DS3231 for the Jetson AGX Xavier L4T kernel. The script builds and installs the DS1307 module. The module for the Dallas DS3231 is the same as the Dallas DS1307, which is register compatible.

Usefull tools for examining the I2C bus: 

$ sudo apt-get install libi2c-dev i2c-tools

The Dallas DS3231 appears as 0x68 on i2c bus 8 on the Jetson AGX Xavier with this wiring:

<blockquote><p>GND Pin 9 ->  DS3231 (GND)<br>
VCC Pin 1 ->  DS3231 (VCC - 3.3V) <br>
SCL Pin 5 ->  DS3231 (SCL)<br>
SDA Pin 3 ->  DS3231 (SDA)</p></blockquote>

Note: VCC,SCL and SDA voltages are dependent on the RTC clock wiring. Most Raspberry Pi or Arduino addon boards that have been level-shifted to 3.3V should work for the SCL and SDA lines. Note also that VCC on most of these boards will work with 3.3V or 5V.

Run:
<blockquote>$ sudo ./prepareModule.sh</blockquote>
to build and install the RTC module. If you have the i2c tools installed, you can check to see if the RTC is available:
<blockquote>$ sudo i2cdetect -y -r 1</blockquote>
The address of the Dallas 3231 will show up as 0x68.

Then attach the RTC device:
<blockquote>$ echo ds3231 0x68 | sudo tee /sys/class/i2c-dev/i2c-8/device/new_device</blockquote>
You can set the clock on the RTC using:
<blockquote>sudo hwclock -w -f /dev/rtc2</blockquote>
You can read the the time stored on the RTC:
<blockquote>sudo hwclock -r -f /dev/rtc2</blockquote>
In order for the RTC to be loaded during startup, add the following two lines /etc/rc.local
(You can modify /etc/rc.local using '$ sudo gedit /etc/rc.local'.
<blockquote>$ echo ds3231 0x68 | sudo tee /sys/class/i2c-dev/i2c-8/device/new_device<br>
$ sudo hwclock -s -f /dev/rtc2</blockquote>
This tells the Jetson to attach the RTC, then set the system time from the RTC. The '-f /dev/rtc2' tells the Jetson that the DS3231 is attached to rtc2. 

For more more information on the installation, please see: https://devtalk.nvidia.com/default/topic/769727/embedded-systems/-howto-battery-backup-rtc/




