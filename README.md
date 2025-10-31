<img width="779" height="890" alt="image" src="https://github.com/user-attachments/assets/93d5c1db-aaff-446c-a0d6-bf381444e507" />


Usage : odin4 [args...]
Odin4 downloader. odin4 version 1.2.13
 -v        SHOW VERSION
 -w        Show License
 -b        Add Bootloader file
 -a        Add AP image file
 -c        Add CP image file
 -s        Add CSC file
 -u        Add UMS file
 -e        Set Nand erase option
 -V        Home binary validation check with pit file
 --reboot  Reboot into normal mode
 --noreboot  Don't reboot after flashing binaries
 --redownload  Reboot into download mode if it possible (not working in normal case)
 --ignore-md5  Ignore MD5SUM. odin don't verify the integrity of files
 --md5sum-only Verify the integrity of files(xxx.tar.MD5). odin don't flash binary
 -d        Set a device path (detect automatically without this option)
 -l        Show downloadable devices path
 --list    Show downloadable devices path and usb location (linux/win)
 --verbose     Verbose. (Single download only)

IMPORTANT : You must set up your system to detect your device on LINUX host.
 create this file: /etc/udev/rules.d/51-android.rules
 to add a line to the file:
 SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"
   (http://developer.android.com/tools/device.html)
 And you maybe need to unload a module cdc_acm before downloading. (This is only needed for older kernels.)
   $sudo rmmod cdc_acm
 OR
   echo "blacklist cdc_acm" > /etc/modprobe.d/cdc_acm-blacklist.conf

Example :
$odin4 -b BL_XXXX.tar.md5 -a AP_XXXX.tar.md5 -c CP_XXXX.tar.md5 -s CSC_XXXX.tar.md5
Example (Select One Device):
$odin4 -l
PATH_OF_DEVICE_A
PATH_OF_DEVICE_B
$odin4 -b BL_XXXX.tar.md5 -a AP_XXXX.tar.md5 -c CP_XXXX.tar.md5 -s CSC_XXXX.tar.md5 -d PATH_OF_DEVICE_A

Odin Community : http://mobilerndhub.sec.samsung.net/hub/site/odin/
