#!/system/bin/sh
# XTweak™ | Main Service Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

MODPATH="/data/adb/modules/xtweak/"

# Load lib
. "${MODPATH}script/xtweak.sh"

MODE=$($getprop persist.xtweak.mode)

# Path variables
XT="/storage/emulated/0/XTweak"
if [ ! -d "$XT" ]; then 
$bb mkdir "$XT"
fi

# Setting up XTweak
if [ "$MODE" = "1" ]; then
M=AUTO-X
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
echo "on" > "/data/xauto.txt"
$bb setsid "${MODPATH}script/xauto.sh" >/data/xauto.log 2>&1 < /dev/null &

elif [ "$MODE" = "2" ]; then
M=ACCUMULATOR
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
_accumulator

elif [ "$MODE" = "3" ]; then
M=EQUALIZER
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
_equalizer

elif [ "$MODE" = "4" ]; then
M=POTENCY
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
_potency

elif [ "$MODE" = "5" ]; then
M=OUTPUT
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
_output
fi
