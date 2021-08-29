#!/system/bin/sh
# XTweak 2021
# Installer related vars and functions
SKIPMOUNT=1
MODDIR=/data/adb/modules
PATH=/data
if [ -e "/data/xtweak" ]; then
    rm -rf "/data/xtweak"
    mkdir -p "$PATH/xtweak"
fi
function make_dirs() {
mkdir -p $MODPATH/system/bin
mkdir -p $MODPATH/system/xbin
mkdir -p $MODPATH/bin
mkdir -p $MODPATH/flags
mkdir -p $MODPATH/script
}
function set_permissions() {
  set_perm_recursive "$MODPATH" 0 0 0755 0644
  set_perm_recursive "$MODPATH/system/bin" 0 0 0755 0755
  set_perm_recursive "$MODPATH/system/xbin" 0 0 0755 0755
  set_perm_recursive "$MODPATH/system/vendor/etc" 0 0 0755 0755
}
function cleanup() {
rm -rf $MODPATH/addon
rm -rf $MODPATH/X-Installer.sh
}
function busybox_installer() {
A=$(getprop ro.product.cpu.abi)
if [ "$A" = "$(echo "$A"|grep "arm64")" ]; then
wget -O "$MODPATH/system/xbin/busybox8" "https://github.com/iamlooper/XTweak/raw/main/busybox/busybox8"

elif [ "$A" = "$(echo "$A"|grep "armeabi")" ]; then
wget -O "$MODPATH/system/xbin/busybox7" "https://github.com/iamlooper/XTweak/raw/main/busybox/busybox7"

elif [ "$A" = "$(echo "$A"|grep "x86_64")" ]; then
wget -O "$MODPATH/system/xbin/busybox64" "https://github.com/iamlooper/XTweak/raw/main/busybox/busybox64"

elif [ "$A" = "$(echo "$A"|grep "x86")" ]; then
wget -O "$MODPATH/system/xbin/busybox86" "https://github.com/iamlooper/XTweak/raw/main/busybox/busybox86"

else
ui_print "[!] Can't detect arc of device, continuing without fetching busybox."
fi
}
function fetch_util() {
wget -O "$MODPATH/system/bin/xqcom" "https://raw.githubusercontent.com/iamlooper/XTweak/main/xtweak/xqcom.sh"
wget -O "$MODPATH/system/bin/xauto" "https://raw.githubusercontent.com/iamlooper/XTweak/main/xtweak/xauto.sh"
wget -O "$MODPATH/system/bin/xmenu" "https://raw.githubusercontent.com/iamlooper/XTweak/main/xtweak/xmenu.sh"
wget -O "$MODPATH/system/bin/xtweak" "https://raw.githubusercontent.com/iamlooper/XTweak/main/xtweak/xtweak.sh"
wget -O "$MODPATH/setup_uperf.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/setup_uperf.sh"
wget -O "$MODPATH/initsvc_uperf.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/initsvc_uperf.sh"
wget -O "$MODPATH/run_uperf.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/run_uperf.sh"
wget -O "$MODPATH/post-fs-data.sh" "https:https://raw.githubusercontent.com/iamlooper/XTweak/main/xtweak/post-fs-data.sh"
wget -O "$MODPATH/service.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/xtweak/service.sh"
wget -O "$MODPATH/system.prop" "https://raw.githubusercontent.com/iamlooper/XTweak/main/xtweak/system.prop"
wget -O "$MODPATH/script/libcgroup.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/libcgroup.sh"
wget -O "$MODPATH/script/libcommon.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/libcommon.sh"
wget -O "$MODPATH/script/libpowercfg.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/libpowercfg.sh"
wget -O "$MODPATH/script/libuperf.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/libuperf.sh"
wget -O "$MODPATH/script/pathinfo.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/pathinfo.sh"
wget -O "$MODPATH/script/powercfg_main.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/powercfg_main.sh"
wget -O "$MODPATH/script/powercfg_once.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/powercfg_once.sh"
wget -O "$MODPATH/script/prepare.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/prepare.sh"
wget -O "$MODPATH/script/start_injector.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/start_injector.sh"
wget -O "$MODPATH/script/vtools-powercfg.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/uperf/script/vtools-powercfg.sh"
wget -O "$MODPATH/system/bin/sqlite3" "https://github.com/iamlooper/XTweak/raw/main/extras/sqlite3"
wget -O "$MODPATH/system/bin/zipalign" "https://github.com/iamlooper/XTweak/raw/main/extras/zipalign"
wget -O "$MODPATH/uninstall.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/xtweak/uninstall.sh"
}
function X_Installer() {
awk '{print}' "$MODPATH"/xtweak_banner
ui_print ""
sleep 3.3  
ui_print "[*] UNIVERSAL POWERFUL FORCEFULNESS KERNEL TWEAKER [*]"
sleep 3.3
if [ -d $MODDIR/KTSR ]; then
ui_print "[*] KTSR Module is present, disabled for security purposes."
touch $MODDIR/KSTR/disable

elif [ -d MODDIR/FDE ]; then
ui_print "[*] FDE.AI Module is present, disabled for security purposes" 
touch $MODDIR/FDE/disable

elif [ -d $MODDIR/MAGNETAR ]; then
ui_print "[*] MAGNETAR Module is present, disabled for security purposes."
touch $MODDIR/MAGNETAR/disable

elif [ -d $MODDIR/ZeetaaTweaks ]; then
ui_print "[*] ZeetaaTweaks Module is present, disabled for security purposes."
touch $MODDIR/ZeetaaTweaks/disable

elif [ -d $MODDIR/KTSRPRO ]; then
ui_print "[*] KTSR PRO Module is present, disabled for security purposes."
touch $MODDIR/KTSRPRO/disable

elif [ -d $MODDIR/ZTS ]; then
ui_print "[*] ZTS Module is present, disabled for security purposes."
touch $MODDIR/ZTS/disable

elif [ -d $MODDIR/Pulsar_Engine ]; then
ui_print "[*] Pulsar Engine Module is present, disabled for security purposes."
touch $MODDIR/Pulsar_Engine/disable

elif [ -d $MODDIR/ktweak ]; then
ui_print "[*] KTweak Module is present, disabled for security purposes."
touch $MODDIR/ktweak/disable

elif [ -d $MODDIR/high_perf_dac ]; then
ui_print "[*] HIGH PERFORMANCE Module is present, disabled for security purposes."
touch $MODDIR/high_perf_dac/disable

elif [ -d $MODDIR/fkm_spectrum_injector ]; then
ui_print "[*] FKM Injector Module is present, disabled for security purposes."
touch $MODDIR/fkm_spectrum_injector/disable

elif [ -d $MODDIR/toolbox8 ]; then
ui_print "[*] Pandora's Box Module is present, disabled for security purposes."
touch $MODDIR/MAGNETAR/disable

elif [ -d $MODDIR/lazy ]; then
ui_print "[*] Lazy Tweaks Module is present, disabled for security purposes."
touch $MODDIR/lazy/disable

elif [[ "$(pm list package ktweak)" ]]; then
ui_print "[*] KTweak App is present, uninstall it to prevent conflicts."

elif [[ "$(pm list package kitana)" ]]; then
ui_print "[*] Kitana App is present, uninstall it to prevent conflicts."

elif [[ "$(pm list package magnetarapp)" ]]; then
ui_print "[*] MAGNETAR App is present, uninstall it to prevent conflicts."

elif [[ "$(pm list package lsandroid)" ]]; then
ui_print "[*] LSpeed App is present, uninstall it to prevent conflicts."

elif [[ "$(pm list package feravolt)" ]]; then
ui_print "[*] FDE.AI App is present, uninstall it to prevent conflicts."
fi
# Unzipping
unzip -o "$ZIPFILE" 'addon/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'system/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'config/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'injector/*' -d "$MODPATH" >&2
# Make dirs
make_dirs
# Preparing test and rest settings
ui_print "[*] Preparing..."
if [ -d $MODDIR/busybox-ndk ] && [ -d $MODDIR/busybox-brutal ] && [ -e /system/xbin/busybox ] && [ -e /system/bin/busybox ] && [ -e /vendor/bin/busybox ]; then
sleep 0.1
else
busybox_installer
fi
sleep 2
ui_print "[*] Fetching various utilities from cloud ☁️ "
fetch_util
. $MODPATH/addon/Volume-Key-Selector/install.sh
sleep 0.1
ui_print "[*] Installing XTweak..."
sleep 2
mode_select
# Exuecute setup_uperf.sh
sh "$MODPATH"/setup_uperf.sh

ui_print " --- Additional Notes --- "
ui_print "[*] Reboot is required"
ui_print "[*] Do not use XTweak with other optimizer modules"
ui_print "[*] (su -c xmenu) to open XTweak Menu in Termux"
ui_print "[*] Report issues to @tweak_projects_discuss on Telegram"
ui_print "[*] Contact @infinity_looper for direct support"
sleep 2.5
set_permissions
cleanup
}
function mode_select() {
ui_print "[*] XTweak Modes Selector: "
sleep 2
ui_print "[*] Volume + = Switch × Volume - = Select "
sleep 1.5
ui_print " 1- Auto X (Automatically changes modes based on user behavior) "
sleep 0.8
ui_print " 2- Accumulator (Reduces cpu and gpu speeds to conserve more battery) "
sleep 0.8
ui_print " 3- Equalizer (Performs equally for battery and performance) "
sleep 0.8
ui_print " 4- Potency (Improve system's latency to provide speed on your phone) "
sleep 0.8
ui_print " 5- Output (Maximizes cpu and gpu speeds to attain highest level performance) "
sleep 0.8
ui_print "[*] Select which mode you want:"
SM=1
while true
do
ui_print "$SM"
if $VKSEL 
then
SM=$((SM + 1))
else 
break
fi
if [ $SM -gt 5 ]
then
SM=1
fi
done

case $SM in
1) FCTEXTAD1="AutoX";;
2) FCTEXTAD1="Accumulator";;
3) FCTEXTAD1="Equalizer";;
4) FCTEXTAD1="Potency";;
5) FCTEXTAD1="Output";;
esac

ui_print "[*] Selected: $FCTEXTAD1 "
ui_print "[*] XTweak has been installed successfully."

if [ "$FCTEXTAD1" -eq "AutoX" ]
then
killall -9 xauto >/dev/null 2>&1
setprop persist.xtweak.mode "1" 2>/dev/null

elif [ "$FCTEXTAD1" -eq "Accumulator" ]
then
killall -9 xauto >/dev/null 2>&1
setprop persist.xtweak.mode "2" 2>/dev/null

elif [ "$FCTEXTAD1" -eq "Equalizer" ]
then
killall -9 xauto >/dev/null 2>&1
setprop persist.xtweak.mode "3" 2>/dev/null

elif [ "$FCTEXTAD1" -eq "Potency" ]
then
killall -9 xauto >/dev/null 2>&1
setprop persist.xtweak.mode "4" 2>/dev/null

elif [ "$FCTEXTAD1" -eq "Output" ]
then
killall -9 xauto >/dev/null 2>&1
setprop persist.xtweak.mode "5" 2>/dev/null
fi
}

# Install
X_Installer

