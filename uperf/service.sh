#!/system/bin/sh
BASEDIR="/data/adb/modules/uperf"
sh $BASEDIR/initsvc_uperf.sh
# Update XTweak scripts
function fetch_util() {
wget -O "$MODPATH/system/bin/x-auto" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/x-auto.sh"
wget -O "$MODPATH/system/bin/x-menu" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/x-menu.sh"
wget -O "$MODPATH/system/bin/xtweak" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/xtweak.sh"
}

fetch_utils

# Start XTweak script
xtweak
