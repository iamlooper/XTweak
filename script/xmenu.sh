#!/system/bin/sh
# XTweak™ | XMenu Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

moddir="/data/adb/modules/xtweak"
modpath="/data/adb/modules/xtweak/"

# Load lib
. "${modpath}script/xtweak.sh"

# Main Variables
mode=$(getprop persist.xtweak.mode)

# Modes settings
if [ "${mode}" = "1" ]; then
m=AUTO-X

elif [ "${mode}" = "2" ]; then
m=ACCUMULATOR

elif [ "${mode}" = "3" ]; then
m=EQUALIZER

elif [ "${mode}" = "4" ]; then
m=POTENCY

elif [ "${mode}" = "5" ]; then
m=OUTPUT
fi

# Check XTweak detection
if [ ! -e "${moddir}" ]; then
echo "[!] XTweak Module not detected!"
exit 1
fi

# /e colors
blue='\e[1;34m' 
green='\e[1;32m' 
purple='\e[1;35m' 
cyan='\e[1;36m' 
red='\e[1;31m' 
white='\e[1;37m'
yellow='\e[01;33m'

# Fetch XTweak info
title=$(grep name= "${modpath}module.prop" | sed "s/name=//")
ver=$(grep version= "${modpath}module.prop" | sed "s/version=//")
codename=$(grep codeName= "${modpath}module.prop" | sed "s/codeName=//")
status=$(grep Status= "${modpath}module.prop" | sed "s/Status=//")
author=$(grep author= "${modpath}module.prop" | sed "s/author=//")

##############################
# MENU
##############################

# Clear previous stuff
clear

# Disable all debugging
set +x

# MENU
echo ""
echo -e $cyan "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e $green " XTweak Advanced Modes Changer & Misc Functions  "
echo -e $cyan "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo -e $cyan "[*] Version : $ver "
echo ""
echo -e $cyan "[*] Codename : $codename "
echo ""
echo -e $cyan "[*] Author : $author "
echo ""
echo -e $cyan "[*] Current Mode: $m "
echo ""
echo -e $cyan "[*] Modes: "
echo ""
echo -e $green "[1] Auto X: Automatically manages various modes via user behavior."
echo ""
echo -e $green "[2] Accumulator: Reduce cpu and gpu speeds and conserve processes to maintain a juicy battery backup."
echo ""
echo -e $yellow "[3] Equalizer: Performs equally between performance and battery, can be used as a daily driver. "
echo ""
echo -e $cyan "[4] Potency: Gives a boost to system's latency to gain silky smooth UI."
echo ""
echo -e $red "[5] Output: Maximizes cpu and gpu speeds, with zero gpu throttling for best performance on your phone, will cause alot of battery drain."
echo ""
echo -e $blue "[*] Other miscellaneous things: "
echo ""
echo -e $blue "[6] Clean junk files"
echo ""
echo -e $blue "[7] RAM Boost"
echo ""
echo -e $blue "[8] Sqlite Optimization"
echo ""
echo -e $blue "[9] Zipalign Optimization"
echo ""
echo -e $blue "[10] Cgroup Optimization"
echo ""
echo -e $blue "[11] Doze Optimization"
echo ""
echo -e $blue "[12] FS-Trim Optimization"
echo ""
echo -e $blue "[13] Net Optimization"
echo ""
echo -e $blue "[14] Disable Thermal"
echo ""
echo -e $blue "[15] Enable Thermal"
echo ""
echo -e $blue "[0] Exit"
echo ""
echo -e $green "[*] Select the desired option: "
read character
case $character in
1) echo -e $cyan "[*] Appying Auto X..." 
setprop persist.xtweak.mode "1" 2>/dev/null
sh "${modpath}script/xtweak_main.sh" >/dev/null 2>&1
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
2) echo -e $cyan "[*] Appying Accumulator..." 
setprop persist.xtweak.mode "2" 2>/dev/null
logging_system &>/dev/null
accumulator &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
3) echo -e $cyan "[*] Applying Equalizer..." 
setprop persist.xtweak.mode "3" 2>/dev/null
logging_system &>/dev/null
equalizer &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
4) echo -e $cyan "[*] Applying Potency..." 
setprop persist.xtweak.mode "4" 2>/dev/null
logging_system &>/dev/null
potency &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
5) echo -e $cyan "[*] Applying Output..." 
setprop persist.xtweak.mode "5" 2>/dev/null
logging_system &>/dev/null
output &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
6) echo -e $cyan "[*] Cleaning junk..."
x_clean &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
7) echo -e $cyan "[*] Boosting RAM..."
sync 
echo "3" > /proc/sys/vm/drop_caches 2>/dev/null
am kill-all 2>/dev/null
am force-stop com.facebook.katana 2>/dev/null
am force-stop com.google 2>/dev/null
am force-stop com.google.android.googlequicksearchbox 2>/dev/null
am force-stop com.whatsapp 2>/dev/null
am force-stop com.facebook.services 2>/dev/null
am force-stop com.android.chrome 2>/dev/null
am force-stop jackpal.androidterm 2>/dev/null
am force-stop yarolegovich.materialterminal 2>/dev/null
am force-stop com.google.android.inputmethod.latin 2>/dev/null
am force-stop com.termoneplus 2>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
8) echo -e $cyan "[*] Applying sqlite opt..." 
x_sqlite &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
9) echo -e $cyan "[*] Applying zipalign opt..." 
x_zipalign &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
10) echo -e $cyan "[*] Applying cgroup opt..." 
x_cgroup &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
11) echo -e $cyan "[*] Applying doze opt..." 
x_doze &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
12) echo -e $cyan "[*] FS-Trimming partitions..." 
fstrim -v /cache 2>/dev/null
fstrim -v /data 2>/dev/null
fstrim -v /system 2>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
13) echo -e $cyan "[*] Applying net opt..." 
x_net &>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
14) echo -e $cyan "[*] Disabling thermal..." 
stop thermal 2>/dev/null
stop thermald 2>/dev/null
stop thermalservice 2>/dev/null
stop mi_thermald 2>/dev/null
stop thermal-engine 2>/dev/null
stop thermanager 2>/dev/null
stop thermal_manager 2>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
15) echo -e $cyan "[*] Enabling thermal..."
start thermal 2>/dev/null
start thermald 2>/dev/null
start thermalservice 2>/dev/null
start mi_thermald 2>/dev/null
start thermal-engine 2>/dev/null
start thermanager 2>/dev/null
start thermal_manager 2>/dev/null
echo -e $cyan "[*] Done!"
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
0) echo -e $cyan "[*] Hope to see you again, bye"
sleep 2.5
exit 0
;;
*) echo -e $red "[*] Response error, opening menu again..."
sleep 2.5
sh "${modpath}script/xmenu.sh"
;;
esac

