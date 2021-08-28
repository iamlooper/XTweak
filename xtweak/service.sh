#!/system/bin/sh
BASEDIR="/data/adb/modules/xtweak"
# Wait for boot to finish completely
while [ $(getprop sys.boot_completed) -ne 1 ]
do
       sleep 1
done

# Sleep until some time to complete init
sleep 30

# Mkdir and give chmod
mkdir -p "/data/xtweak"
chmod -R 0755 "/data/xtweak"

# Start uperf
sh $BASEDIR/initsvc_uperf.sh

# Start qcom optimization
xqcom

# Start XTweak script
xtweak
