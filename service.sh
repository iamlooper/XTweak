#!/system/bin/sh
# XTweak 2021

MODPATH="/data/adb/modules/xtweak"

# Wget Tool Function
_wget(){
/data/adb/modules/xtweak/bin/wget "$@"
}

# Sleep until boot completed
until [ "$(getprop sys.boot_completed)" = "1" ] || [ "$(getprop dev.bootcomplete)" = "1" ]
do
       sleep 1
done

# Sleep until some time to complete boot and init
sleep 60

# Update main scripts
_wget -O "${MODPATH}/script/accumulator.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/accumulator.sh"
_wget -O "${MODPATH}/script/equalizer.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/equalizer.sh"
_wget -O "${MODPATH}/script/potency.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/potency.sh"
_wget -O "${MODPATH}/script/output.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/output.sh"
_wget -O "${MODPATH}/script/xauto.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/xauto.sh"
_wget -O "${MODPATH}/script/xmenu.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/xmenu.sh"
_wget -O "${MODPATH}/script/xtweak.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/xtweak.sh" 
_wget -O "${MODPATH}/script/xtweak_utility.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/xtweak_utility.sh"
_wget -O "${MODPATH}/system/bin/xmenu" "https://raw.githubusercontent.com/iamlooper/XTweak/main/system/bin/xmenu"
_wget -O "${MODPATH}/system/bin/xtweak" "https://raw.githubusercontent.com/iamlooper/XTweak/main/system/bin/xtweak"

# Start qcom optimization
sh "/system/bin/xqcom"

# Start XTweak
sh "/system/bin/xtweak"