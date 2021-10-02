#!/system/bin/sh
# XTweak Menu Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

MODPATH="/data/adb/modules/xtweak"

# Load utility lib
. "$MODPATH/script/xtweak_utility.sh"
$sleep 1

# Main Variables
MODE=$($getprop persist.xtweak.mode)

# Logging path variables
PATH="/storage/emulated/0"
if [ ! -d "$PATH/XTweak" ]; then 
$mkdir "$PATH/XTweak"
fi

# Modes settings
if [ "$MODE" = "1" ]; then
M=AUTO-X

elif [ "$MODE" = "2" ]; then
M=ACCUMULATOR

elif [ "$MODE" = "3" ]; then
M=EQUALIZER

elif [ "$MODE" = "4" ]; then
M=POTENCY

elif [ "$MODE" = "5" ]; then
M=OUTPUT
fi

# Check XTweak detection
if [ ! -e "$MODPATH" ]; then
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
TITLE=$($grep name= "$MODPATH/module.prop" | $sed "s/name=//")
VER=$($grep version= "$MODPATH/module.prop" | $sed "s/version=//")
CODENAME=$($grep codeName= "$MODPATH/module.prop" | $sed "s/codeName=//")
STATUS=$($grep Status= "$MODPATH/module.prop" | $sed "s/Status=//")
AUTHOR=$($grep author= "$MODPATH/module.prop" | $sed "s/author=//")

##############################
# MENU
##############################

# Clear previous stuff
$clear

# Disable all debugging
set +x

# MENU
echo ""
echo -e $cyan "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e $green " XTweak Advanced Modes Changer & Misc Functions  "
echo -e $cyan "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo -e $cyan "[*] Version : $VER "
echo ""
echo -e $cyan "[*] Codename : $CODENAME "
echo ""
echo -e $cyan "[*] Author : $AUTHOR "
echo ""
echo -e $cyan "[*] Current Mode: $M "
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
echo -e $blue "[13] Disable Thermal"
echo ""
echo -e $blue "[14] Enable Thermal"
echo ""
echo -e $blue "[0] Exit"
echo ""
echo -e $green "[*] Select the desired option: "
read character
case $character in
1) echo -e $cyan "[*] Appying Auto X..." 
$setprop persist.xtweak.mode "1" 2>/dev/null
sh "$MODPATH/script/xtweak.sh" >/dev/null 2>&1
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
2) echo -e $cyan "[*] Appying Accumulator..." 
$setprop persist.xtweak.mode "2" 2>/dev/null
logging_system >/dev/null 2>&1
sh "$MODPATH/script/accumulator.sh" >/dev/null 2>&1
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
3) echo -e $cyan "[*] Applying Equalizer..." 
$setprop persist.xtweak.mode "3" 2>/dev/null
logging_system >/dev/null 2>&1
sh "$MODPATH/script/equalizer.sh" >/dev/null 2>&1
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
4) echo -e $cyan "[*] Applying Potency..." 
$setprop persist.xtweak.mode "4" 2>/dev/null
logging_system >/dev/null 2>&1
sh "$MODPATH/script/potency.sh" >/dev/null 2>&1
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
5) echo -e $cyan "[*] Applying Output..." 
$setprop persist.xtweak.mode "5" 2>/dev/null
logging_system >/dev/null 2>&1
sh "$MODPATH/script/output.sh" >/dev/null 2>&1
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
6) echo -e $cyan "[*] Cleaning junk..."
x_clean >/dev/null 2>&1
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
7) echo -e $cyan "[*] Boosting RAM..."
$sync 
echo "3" > /proc/sys/vm/drop_caches 2>/dev/null
$am kill-all 2>/dev/null
$am force-stop com.facebook.katana 2>/dev/null
$am force-stop com.google 2>/dev/null
$am force-stop com.google.android.googlequicksearchbox 2>/dev/null
$am force-stop com.whatsapp 2>/dev/null
$am force-stop com.facebook.services 2>/dev/null
$am force-stop com.android.chrome 2>/dev/null
$am force-stop jackpal.androidterm 2>/dev/null
$am force-stop yarolegovich.materialterminal 2>/dev/null
$am force-stop com.google.android.inputmethod.latin 2>/dev/null
$am force-stop com.termoneplus 2>/dev/null
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
8) echo -e $cyan "[*] Applying sqlite opt..." 
x_sqlite &>/dev/null
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
9) echo -e $cyan "[*] Applying zipalign opt..." 
x_zipalign >/dev/null 2>&1
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
10) echo -e $cyan "[*] Applying cgroup opt..." 
x_cgroup >/dev/null 2>&1
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
11) echo -e $cyan "[*] Applying doze opt..." 
x_doze >/dev/null 2>&1
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
12) echo -e $cyan "[*] FS-Trimming partitions..." 
fstrim -v /cache 2>/dev/null
fstrim -v /data 2>/dev/null
fstrim -v /system 2>/dev/null
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
13) echo -e $cyan "[*] Disabling thermal..." 
stop thermal 2>/dev/null
stop thermald 2>/dev/null
stop thermalservice 2>/dev/null
stop mi_thermald 2>/dev/null
stop thermal-engine 2>/dev/null
stop thermanager 2>/dev/null
stop thermal_manager 2>/dev/null
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
14) echo -e $cyan "[*] Enabling thermal..."
start thermal 2>/dev/null
start thermald 2>/dev/null
start thermalservice 2>/dev/null
start mi_thermald 2>/dev/null
start thermal-engine 2>/dev/null
start thermanager 2>/dev/null
start thermal_manager 2>/dev/null
echo -e $cyan "[*] Done!"
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
0) echo -e $cyan "[*] Hope to see you again, bye"
$sleep 2.5
exit 0
;;
*) echo -e $red "[*] Response error, opening menu again..."
$sleep 2.5
sh "$MODPATH/script/xmenu.sh"
;;
esac

