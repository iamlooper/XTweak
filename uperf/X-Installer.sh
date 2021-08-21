#!/system/bin/sh
# XTweak 2021
# FULLY MODIFIED BY INFINITYLOOPER
# SOME TEMPLATE STUFF BY Zackptg5
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true
SKIPUNZIP=1
MODDIR=/data/adb/modules
A=$(getprop ro.product.cpu.abi);
COMPT=$(cat $MODPATH/test)
if [[ -e "/dev/XTweak" ]]; then
    rm -rf "/dev/XTweak"
fi
Path=/dev
if [ ! -d $Path/XTweak ]; then
 mkdir -p $Path/XTweak
fi
XT=$Path/XTweak
function abort() {
  ui_print "$1"
  rm -rf $MODPATH 2>/dev/null
  cleanup
  rm -rf $TMPDIR 2>/dev/null
  exit 1
}
function cleanup() {
rm -rf $MODPATH/addon 2>/dev/null
rm -rf $MODPATH/test 2>/dev/null
}
function busybox_installer() {
if [ "$A" = "$(echo "$A"|grep "arm64")" ]; then
wget -O "$MODPATH/system/xbin/busybox8" "https://github.com/anylooper/XTweak/raw/main/busybox/busybox8"

elif [ "$A" = "$(echo "$A"|grep "armeabi")" ]; then
wget -O "$MODPATH/system/xbin/busybox7" "https://github.com/anylooper/XTweak/raw/main/busybox/busybox7"

elif [ "$A" = "$(echo "$A"|grep "x86_64")" ]; then
wget -O "$MODPATH/system/xbin/busybox64" "https://github.com/anylooper/XTweak/raw/main/busybox/busybox64"

elif [ "$A" = "$(echo "$A"|grep "x86")" ]; then
wget -O "$MODPATH/system/xbin/busybox86" "https://github.com/anylooper/XTweak/raw/main/busybox/busybox86"

else
abort "[!] Can't detect arc of device."
fi
}
function fetch_util() {
wget -O "$MODPATH/system/bin/x-auto" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/x-auto.sh"
wget -O "$MODPATH/system/bin/x-menu" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/x-menu.sh"
wget -O "$MODPATH/system/bin/xtweak" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/xtweak.sh"
wget -O "$MODPATH/setup_uperf.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/setup_uperf.sh"
wget -O "$MODPATH/initsvc_uperf.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/initsvc_uperf.sh"
wget -O "$MODPATH/run_uperf.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/run_uperf.sh"
wget -O "$MODPATH/post-fs-data.sh" "https:https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/post-fs-data.sh"
wget -O "$MODPATH/service.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/service.sh"
wget -O "$MODPATH/system.prop" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/system.prop"
wget -O "$MODPATH/busybox/busybox-arm-selinux" "https://github.com/anylooper/XTweak/raw/main/uperf/busybox/busybox-arm-selinux"
wget -O "$MODPATH/busybox/busybox-arm64-selinux" "https://github.com/anylooper/XTweak/raw/main/uperf/busybox/busybox-arm64-selinux"
wget -O "$MODPATH/script/libcgroup.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/libcgroup.sh"
wget -O "$MODPATH/script/libcommon.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/libcommon.sh"
wget -O "$MODPATH/script/libpowercfg.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/libpowercfg.sh"
wget -O "$MODPATH/script/libuperf.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/libuperf.sh"
wget -O "$MODPATH/script/pathinfo.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/pathinfo.sh"
wget -O "$MODPATH/script/powercfg_main.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/powercfg_main.sh"
wget -O "$MODPATH/script/powercfg_once.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/powercfg_once.sh"
wget -O "$MODPATH/script/prepare.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/prepare.sh"
wget -O "$MODPATH/script/start_injector.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/start_injector.sh"
wget -O "$MODPATH/script/vtools-powercfg.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/vtools-powercfg.sh"
wget -O "$MODPATH/system/bin/bash" "https://github.com/anylooper/XTweak/raw/main/extras/bash"
wget -O "$MODPATH/system/bin/sqlite3" "https://github.com/anylooper/XTweak/raw/main/extras/sqlite3"
wget -O "$MODPATH/system/bin/zipalign" "https://github.com/anylooper/XTweak/raw/main/extras/zipalign"
wget -O "$MODPATH/uninstall.sh" "https://raw.githubusercontent.com/anylooper/XTweak/main/extras/uninstall.sh"
wget -O "$TMPDIR/addon/Volume-Key-Selector/tools/arm/keycheck" "https://github.com/anylooper/XTweak/raw/main/extras/keycheckarm"
wget -O "$TMPDIR/addon/Volume-Key-Selector/tools/x86/keycheck" "https://github.com/anylooper/XTweak/raw/main/extras/keycheckx86"
}
function X_Installer() {
awk '{print}' "$MODPATH"/xtweak_banner
ui_print ""
sleep 3.3  
ui_print "[*] UNIVERSAL POWERFUL FORCEFULNESS KERNEL TWEAKER "
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
# Unzipping and preparing wget
unzip -o "$ZIPFILE" 'META-INF/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'addon/*' -d "$TMPDIR" >&2
unzip -o "$ZIPFILE" 'system/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'bin/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'config/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'flags/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'injector/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'script/*' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'busybox/*' -d "$MODPATH" >&2

# Preparing test and rest settings
ui_print "[*] Preparing compatibility test..."
if [[ -d $MODDIR/busybox-ndk ]] || [[ -d $MODDIR/busybox-brutal ]] || [[ -e /system/xbin/busybox ]] || [[ -e /system/bin/busybox ]] || [[ -e /vendor/bin/busybox ]]; then
sleep 0.1
else
busybox_installer
fi
touch $MODPATH/test
echo "1" > $MODPATH/test 
if [ "$COMPT" -eq "$(echo "$COMPT"|grep "1")" ]; then
sleep 0.1
else
sleep 0.1
fi
if [ -d /data/adb/modules/xtweak ]; then
magiskhide disable
rm -Rf /data/adb/modules/xtweak/*
magiskhide enable
fi
ui_print "[*] Done checking compatibility, continuing to installation..."
sleep 2
ui_print "[*] Fetching various utilities from cloud ☁️ "
fetch_util
. $TMPDIR/addon/Volume-Key-Selector/install.sh
sleep 0.1
ui_print "[*] Installing XTweak..."
sleep 2
mode_select
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
1 ) FCTEXTAD1="AutoX";;
2 ) FCTEXTAD1="Accumulator";;
3 ) FCTEXTAD1="Equalizer";;
4 ) FCTEXTAD1="Potency";;
5 ) FCTEXTAD1="Output";;
esac

ui_print "[*] Selected: $FCTEXTAD1 "
ui_print "[*] XTweak has been installed successfully."

if [[ "$FCTEXTAD1" == "AutoX" ]]
then
killall -9 x-auto >/dev/null 2>&1
setprop persist.xtweak.mode "1" 2>/dev/null

elif [[ "$FCTEXTAD1" == "Accumulator" ]]
then
killall -9 x-auto >/dev/null 2>&1
setprop persist.xtweak.mode "2" 2>/dev/null

elif [[ "$FCTEXTAD1" == "Equalizer" ]]
then
killall -9 x-auto >/dev/null 2>&1
setprop persist.xtweak.mode "3" 2>/dev/null

elif [[ "$FCTEXTAD1" == "Potency" ]]
then
killall -9 x-auto >/dev/null 2>&1
setprop persist.xtweak.mode "4" 2>/dev/null

elif [[ "$FCTEXTAD1" == "Output" ]]
then
killall -9 x-auto >/dev/null 2>&1
setprop persist.xtweak.mode "5" 2>/dev/null
fi

# Exuecute setup_uperf.sh
sh "$MODPATH"/setup_uperf.sh
[ "$?" != "0" ] && ui_print "[*] Uperf setup script not found, finishing installations..."
rm "$MODPATH"/setup_uperf.sh

ui_print " --- Additional Notes --- "
ui_print "[*] Reboot is required"
ui_print "[*] Do not use XTweak with other optimizer modules"
ui_print "[*] (su -c x-menu) to open XTweak Menu in Termux"
ui_print "[*] Report issues to @tweak_projects_discuss on Telegram"
ui_print "[*] Contact @infinity_looper for direct support"
sleep 4
ui_print "[*] Done!"
set_permissions
cleanup
}
#
function set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
  set_perm_recursive $MODPATH/system/vendor/etc 0 0 0755 0755 
  chmod -R 0755 $MODPATH/*
}
function template_essentials() {
# Enable debug logs
set -x
# Only in recovery
if ! $BOOTMODE; then
  ui_print "[*] Only uninstall is supported in recovery"
  ui_print ""
  ui_print "[*] Uninstalling!"
  ui_print ""
  touch "$MODPATH"/remove
  [ -s "$INFO" ] && install_script "$MODPATH"/uninstall.sh || rm -f "$INFO" "$MODPATH"/uninstall.sh
  recovery_cleanup
  cleanup
  rm -Rf "$NVBASE"/modules_update/"$MODID" "$TMPDIR" 2>/dev/null
  exit 0
fi
}
