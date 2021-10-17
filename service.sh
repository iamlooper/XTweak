#!/system/bin/sh
# XTweak™ | Service Script

modpath="/data/adb/modules/xtweak/"

# Sleep until boot completed
until [ "$(getprop sys.boot_completed)" = "1" ] || [ "$(getprop dev.bootcomplete)" = "1" ]
do
       sleep 2
done

# Sleep until some time to complete init
sleep 60

# Start qcom optimization
sh "${modpath}script/xqcom.sh"

# Start XTweak
sh "/system/bin/xtweak"