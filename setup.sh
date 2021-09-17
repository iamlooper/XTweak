###########################
# MMT - BOURNE SETUP SCRIPT
###########################

# Config Vars
# Choose if you want to skip mount for your module or not.
SKIPMOUNT=false
# Set true if you want to load system.prop
PROPFILE=true
# Set true if you want to load post-fs-data.sh
POSTFSDATA=false
# Set true if you want to load service.sh
LATESTARTSERVICE=true
# Set true if you want to clean old files in module before injecting new module
CLEANSERVICE=true
# Select true if you want to want to debug
DEBUG=true
# Select this if you want to add cloud support to your scripts
#CLOUDSUPPPORT=true
# Add cloud host path to this variable
#CLOUDHOST=

# Custom var
MODDIR=/data/adb/modules

# Input options which you want to be replaced
REPLACE="
"

# Set what you want to be displayed on header on installation process
mod_info_print() {
awk '{print}' "$MODPATH"/xtweak_banner
ui_print ""
ui_print "[⚡] UNIVERSAL POWERFUL FORCEFULNESS KERNEL TWEAKER [⚡]"
}

# Default extraction path is to $MODPATH. Change the logic to whatever you want.
install_module() {
# Unzip
unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR >&2
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'script/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'bin/*' -d $MODPATH >&2

# Preparing test and rest settings
ui_print "[*] Preparing..."
sleep 1.5
if [ -d $MODDIR/KTSR ]; then
ui_print "[*] KTSR Module is present, disabled for security purposes."
touch $MODDIR/KSTR/disable

elif [ -d $MODDIR/FDE ]; then
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

elif [ "$(pm list package ktweak)" ]; then
ui_print "[*] KTweak App is present, uninstall it to prevent conflicts."

elif [ "$(pm list package kitana)" ]; then
ui_print "[*] Kitana App is present, uninstall it to prevent conflicts."

elif [ "$(pm list package magnetarapp)" ]; then
ui_print "[*] MAGNETAR App is present, uninstall it to prevent conflicts."

elif [ "$(pm list package lsandroid)" ]; then
ui_print "[*] LSpeed App is present, uninstall it to prevent conflicts."

elif [ "$(pm list package feravolt)" ]; then
ui_print "[*] FDE.AI App is present, uninstall it to prevent conflicts."
fi
ui_print "[*] Extracting XTweak files..."
sleep 1.5

# Load Vol Key Selector
. $TMPDIR/addon/Volume-Key-Selector/install.sh

ui_print "[*] Installing XTweak..."
sleep 2
ui_print "[*] XTweak Modes Selector: "
sleep 2
ui_print "[*] Volume + = Switch × Volume - = Select "
sleep 1.5
ui_print "[1] Auto X (Automatically changes modes based on user behavior) "
sleep 0.8
ui_print "[2] Accumulator (Reduces cpu and gpu speeds to conserve more battery) "
sleep 0.8
ui_print "[3] Equalizer (Performs equally for battery and performance) "
sleep 0.8
ui_print "[4] Potency (Improve system's latency to provide speed on your phone) "
sleep 0.8
ui_print "[5] Output (Maximizes cpu and gpu speeds to attain highest level performance) "
sleep 0.8
ui_print "[*] Select which mode you want:"
SM=1
while true
do
ui_print "   $SM"
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

if [[ "$FCTEXTAD1" == "AutoX" ]]; then
echo "off" > "/storage/emulated/0/XTweak/xauto.txt"
setprop persist.xtweak.mode "1" 2>/dev/null

elif [[ "$FCTEXTAD1" == "Accumulator" ]]; then
echo "off" > "/storage/emulated/0/XTweak/xauto.txt"
setprop persist.xtweak.mode "2" 2>/dev/null

elif [[ "$FCTEXTAD1" == "Equalizer" ]]; then
echo "off" > "/storage/emulated/0/XTweak/xauto.txt"
setprop persist.xtweak.mode "3" 2>/dev/null

elif [[ "$FCTEXTAD1" == "Potency" ]]; then
echo "off" > "/storage/emulated/0/XTweak/xauto.txt"
setprop persist.xtweak.mode "4" 2>/dev/null

elif [[ "$FCTEXTAD1" == "Output" ]]; then
echo "off" > "/storage/emulated/0/XTweak/xauto.txt"
setprop persist.xtweak.mode "5" 2>/dev/null
fi
sleep 1
ui_print "[*] XTweak has been installed successfully."
sleep 1.5
ui_print " --- Additional Notes --- "
ui_print "[*] Reboot is required"
ui_print "[*] Do not use XTweak with other optimizer modules"
ui_print "[*] (su -c xmenu) to open XTweak Menu in Termux"
ui_print "[*] Report issues to @tweak_projects_discuss on Telegram"
ui_print "[*] You can find me at iamlooper @ telegram for direct support"
sleep 4
}

# Set permissions
set_permissions() {
  set_perm_recursive "$MODPATH" 0 0 0755 0644
  set_perm_recursive "$MODPATH/system/bin" 0 0 0755 0755
  set_perm_recursive "$MODPATH/system/xbin" 0 0 0755 0755
  set_perm_recursive "$MODPATH/system/vendor/etc" 0 0 0755 0755
  set_perm_recursive "$MODPATH/script" 0 0 0755 0755
  set_perm_recursive "$MODPATH/bin" 0 0 0755 0755
}