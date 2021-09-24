#!/system/bin/sh
# XTweak 2021
# Sleep until boot completed
until [ "$(getprop sys.boot_completed)" = "1" ] || [ "$(getprop dev.bootcomplete)" = "1" ]
do
       sleep 1
done

# Sleep until some time to complete boot and init
sleep 60

# Start qcom optimization
sh "/system/bin/xqcom"

# Start XTweak
sh "/system/bin/xtweak"