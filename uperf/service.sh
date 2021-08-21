#!/system/bin/sh
BASEDIR="/data/adb/modules/xtweak"
function fetch_util() {
wget -O "$MODPATH/system/bin/xqcom" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/xqcom.sh"
wget -O "$MODPATH/system/bin/x-auto" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/x-auto.sh"
wget -O "$MODPATH/system/bin/x-menu" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/x-menu.sh"
wget -O "$MODPATH/system/bin/xtweak" "https://raw.githubusercontent.com/anylooper/XTweak/main/uperf/script/xtweak.sh"
}
function wait_until_sign_in() {
    # we doesn't have the permission to rw "/sdcard" before the user unlocks the screen
    while [ $(getprop sys.boot_completed) -eq 1 ] | [ ! -d "/sdcard" ]
    do
       sleep 0.1
    done
    local test_file="/sdcard/.PERMISSION_TEST"
    touch "$test_file"
    while [ ! -f "$test_file" ]; do
        touch "$test_file"
        sleep 0.1
    done
    rm -Rf "$test_file"
}

# Wait until boot completed and perm given to write
wait_until_login

# Start uperf
sh $BASEDIR/initsvc_uperf.sh

# Updated XTweak scripts
fetch_utils

# Start qcom optimization
xqcom

# Start XTweak script
xtweak
