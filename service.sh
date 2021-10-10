#!/system/bin/sh
# XTweak 2021

MODPATH="/data/adb/modules/xtweak/"

# Sleep until boot completed
until [ "$(getprop sys.boot_completed)" = "1" ] || [ "$(getprop dev.bootcomplete)" = "1" ]
do
       sleep 1
done

# Sleep until some time to complete init
sleep 60

# Start qcom optimization
sh "${MODPATH}script/xqcom.sh"

# Start XTweak
sh "/system/bin/xtweak"