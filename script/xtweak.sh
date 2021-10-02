#!/system/bin/sh
# XTweak Main Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

MODPATH="/data/adb/modules/xtweak"

# Load utility lib
. "$MODPATH/script/xtweak_utility.sh"
$sleep 1

MODE=$($getprop persist.xtweak.mode)

# Logging path variables
PATH="/storage/emulated/0"
if [ ! -d "$PATH/XTweak" ]; then 
$mkdir "$PATH/XTweak"
fi

# Setting up XTweak
if [ "$MODE" = "1" ]; then
M=AUTO-X
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
echo "on" > "/data/xauto.txt"
$setsid "$MODPATH/script/xauto.sh" >/data/xauto.log 2>&1 < /dev/null &

elif [ "$MODE" = "2" ]; then
M=ACCUMULATOR
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
sh "$MODPATH/script/accumulator.sh"

elif [ "$MODE" = "3" ]; then
M=EQUALIZER
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
sh "$MODPATH/script/equalizer.sh"

elif [ "$MODE" = "4" ]; then
M=POTENCY
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
sh "$MODPATH/script/potency.sh"

elif [ "$MODE" = "5" ]; then
M=OUTPUT
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
sh "$MODPATH/script/output.sh"
fi
