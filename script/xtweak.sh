#!/system/bin/bash
# XTweak Main Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

MODPATH="/data/adb/modules/xtweak"

# Load utility lib
source "$MODPATH/script/xtweak_utility.sh"

MODE=$(_getprop persist.xtweak.mode)

# Logging path variables
PATH="/storage/emulated/0"
if [[ ! -d "$PATH/XTweak" ]]; then 
_mkdir "$PATH/XTweak"
fi

# Setting up XTweak
if [[ "$MODE" == "1" ]]; then
M=AUTO-X
_killall -9 xauto >/dev/null 2>&1
_pkill -f xauto >/dev/null 2>&1
logging_system
(. "$MODPATH/bin/xauto" &) &

elif [[ "$MODE" == "2" ]]; then
M=ACCUMULATOR
_killall -9 xauto >/dev/null 2>&1
_pkill -f xauto >/dev/null 2>&1
logging_system
x_sqlite &>/dev/null
_bash "$MODPATH/script/accumulator.sh"

elif [[ "$MODE" == "3" ]]; then
M=EQUALIZER
_killall -9 xauto >/dev/null 2>&1
_pkill -f xauto >/dev/null 2>&1
logging_system
x_sqlite &>/dev/null
_bash "$MODPATH/script/equalizer.sh"

elif [[ "$MODE" == "4" ]]; then
M=POTENCY
_killall -9 xauto >/dev/null 2>&1
_pkill -f xauto >/dev/null 2>&1
logging_system
x_sqlite &>/dev/null
_bash "$MODPATH/script/potency.sh"

elif [[ "$MODE" == "5" ]]; then
M=OUTPUT
_killall -9 xauto >/dev/null 2>&1
_pkill -f xauto >/dev/null 2>&1
logging_system
x_sqlite &>/dev/null
_bash "$MODPATH/script/output.sh"
fi
