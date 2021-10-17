#!/system/bin/sh
# XTweak™ | Main Service Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

modpath="/data/adb/modules/xtweak/"

# Load lib
. "${modpath}script/xtweak.sh"

mode=$(getprop persist.xtweak.mode)

# Path variables
xt="/storage/emulated/0/XTweak"
if [ ! -d "${xt}" ]; then 
mkdir "${xt}"
fi

# Setting up XTweak
if [ "${mode}" = "1" ]; then
m=AUTO-X
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
echo "on" > "/data/xauto.txt"
(. "${modpath}script/xauto.sh" &) &

elif [ "${mode}" = "2" ]; then
m=ACCUMULATOR
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
x_cgroup &>/dev/null
accumulator
x_net &>/dev/null

elif [ "${mode}" = "3" ]; then
m=EQUALIZER
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
x_cgroup &>/dev/null
equalizer
x_net &>/dev/null

elif [ "${mode}" = "4" ]; then
m=POTENCY
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
x_cgroup &>/dev/null
potency
x_net &>/dev/null

elif [ "${mode}" = "5" ]; then
m=OUTPUT
echo "off" > "/data/xauto.txt"
logging_system &>/dev/null
x_sqlite &>/dev/null
x_cgroup &>/dev/null
output
x_net &>/dev/null
fi
