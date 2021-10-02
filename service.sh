#!/system/bin/sh
# XTweak 2021

MODPATH="/data/adb/modules/xtweak"
wget="/data/adb/modules/xtweak/bin/wget"

# Sleep until boot completed
until [ "$(getprop sys.boot_completed)" = "1" ] || [ "$(getprop dev.bootcomplete)" = "1" ]
do
       sleep 1
done

# Sleep until some time to complete init
sleep 60

# Update main scripts
$wget -O "${MODPATH}/script/accumulator.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/accumulator.sh"
$wget -O "${MODPATH}/script/equalizer.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/equalizer.sh"
$wget -O "${MODPATH}/script/potency.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/potency.sh"
$wget -O "${MODPATH}/script/output.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/output.sh"
$wget -O "${MODPATH}/script/xauto.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/xauto.sh"
$wget -O "${MODPATH}/script/xmenu.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/xmenu.sh"
$wget -O "${MODPATH}/script/xtweak.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/xtweak.sh" 
$wget -O "${MODPATH}/script/xtweak_utility.sh" "https://raw.githubusercontent.com/iamlooper/XTweak/main/script/xtweak_utility.sh"
$wget -O "${MODPATH}/system/bin/xmenu" "https://raw.githubusercontent.com/iamlooper/XTweak/main/system/bin/xmenu"
$wget -O "${MODPATH}/system/bin/xtweak" "https://raw.githubusercontent.com/iamlooper/XTweak/main/system/bin/xtweak"

# Start qcom optimization
sh "/system/bin/xqcom"

# Start XTweak
sh "/system/bin/xtweak"