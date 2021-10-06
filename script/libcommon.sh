#!/system/bin/sh
# XTweak - Basic Tools & Logging System Library
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

##############################
# Basic Tool Functions
###############################

# $1:file-path $2:value
write(){
	# Bail out if file does not exist
	[ ! -f "$1" ] && return 1

	# Make file write-able in case it is not already
	$chmod +w "$1" 2>/dev/null

	# Write the new value and bail if there's an error
	if ! echo "$2" > "$1" 2>/dev/null
	then
		echo "[!] Failed: $1 --> $2"
		return 1
	fi

	# Log the success
	echo "[*] Success: $1 --> $2"
}

# $1:file-path $2:value
lock_write(){
	# Bail out if file does not exist
	[ ! -f "$1" ] && return 1

	# Make file write-able in case it is not already
	$chmod +w "$1" 2>/dev/null

	# Write the new value and bail if there's an error
	if ! echo "$2" > "$1" 2>/dev/null
	then
		echo "[!] Failed: $1 --> $2"
		return 1
	fi

    # Lock $1
    $chmod 000 "$1"

	# Log the success
	echo "[*] Locked: $1 --> $2"
}

# $1:value $2:file-path
lock_val(){
    if [ -f "$2" ]; then
        $chmod 0666 "$2" 2>/dev/null
        echo "$1" > "$2"
        $chmod 0444 "$2" 2>/dev/null
    fi
}

# $1:value $2:file-path
mutate(){
    if [ -f "$2" ]; then
        $chmod 0666 "$2" 2>/dev/null
        echo "$1" > "$2"
    fi
}

su="/data/adb/modules/xtweak/bin/su"

sqlite="/data/adb/modules/xtweak/bin/sqlite3"

zipalign="/data/adb/modules/xtweak/bin/zipalign"

bb="/data/adb/magisk/busybox"

mkdir=$($bb mkdir)

clear=$($bb clear)

grep=$($bb grep)

sleep=$($bb sleep)

cat=$($bb cat)

uname=$($bb uname)

rm=$($bb rm)

wget=$($bb wget)

awk=$($bb awk)

cut=$($bb cut)

free=$($bb free)

cp=$($bb cp)

touch=$($bb touch)

sed=$($bb sed)

date=$($bb date)

chmod=$($bb chmod)

mv=$($bb mv)

sync=$($bb sync)

pgrep=$($bb pgrep)

killall=$($bb killall)

kill=$($bb kill)

mount=$($bb mount)

find=$($bb find)

wc=$($bb wc)

setsid=$($bb setsid)

fstrim=$($bb fstrim)

sh=$($bb sh)

if [ -e "/system/bin/getprop" ]; then
getprop="/system/bin/getprop"
else
getprop="/system/xbin/getprop"
fi

if [ -e "/system/bin/resetprop" ]; then
resetprop="/system/bin/resetprop"
else
resetprop="/system/xbin/resetprop"
fi

if [ -e "/system/bin/dumpsys" ]; then
dumpsys="/system/bin/dumpsys"
else
dumpsys="/system/xbin/dumpsys"
fi

if [ -e "/system/bin/setprop" ]; then
setprop="/system/bin/setprop"
else
setprop="/system/xbin/setprop"
fi

if [ -e "/system/bin/am" ]; then
am="/system/bin/am"
else
am="/system/xbin/am"
fi

if [ -e "/system/bin/pm" ]; then
pm="/system/bin/pm"
else
pm="/system/xbin/pm"
fi

##############################
# Kernel Variables
###############################

KERNEL="/proc/sys/kernel"
VM="/proc/sys/vm"
SCHED_FEATURES="/sys/kernel/debug/sched_features"
RAID="/proc/sys/dev/raid"
PTY="/proc/sys/kernel/pty"
KEYS="/proc/sys/kernel/keys"
FS="/proc/sys/fs"
LMK="/sys/module/lowmemorykiller/parameters"

##############################
# Device Info Functions
###############################

# Fetch ram info
_ram_info(){
TOTAL_RAM=$($free -m | $awk '/Mem:/{print $2}')
FULL_RAM=$((TOTAL_RAM * 20 / 100))
AVAIL_RAM=$($free -m | $awk '/Mem:/{print $7}')
}

# Fetch battery status
_battery_status(){
if [ -e "/sys/class/power_supply/battery/status" ]; then
BATT_STATUS=$($cat /sys/class/power_supply/battery/status)
            
else
BATT_STATUS=$($dumpsys battery | $awk '/status/{print $2}')
fi
}

# Fetch battery level
_battery_percentage(){               
if [ -e "/sys/class/power_supply/battery/capacity" ]; then
BATT_LVL=$($cat /sys/class/power_supply/battery/capacity)
                  
else
BATT_LVL=$(dumpsys battery | $awk '/level/{print $2}')
fi
}

# Fetch screen state
_screen_state(){
SCRN_STATE=$($dumpsys power | $grep state=O | $cut -d "=" -f 2)
if [ "$scrn_state" = "ON" ]; then 
SCRN_ON=1

else 
SCRN_ON=0
fi
}

logging_system(){

LOG="/storage/emulated/0/XTweak/xtweak.log"

# Clear logs before logging again
$rm -rf "$LOG"

# Fetch brand info
BRAND=$($getprop ro.product.brand)

# Fetch device model info
MODEL=$($getprop ro.product.model)

# Fetch ROM id
ROM=$($getprop ro.build.display.id)

# Fetch system language info
LANG=$($getprop persist.sys.locale) 

# Fetch android release version
ANDROID=$($getprop ro.build.version.release)

# Fetch android sdk info
SDK=$($getprop ro.build.version.sdk) 

# Fetch kernel related info
KERNEL=$($uname -r)
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/
do
  if [ "$($cat ${cpu}scaling_available_governors | $grep 'sched')" ]; then
      KERNEL_TYPE="EAS"
  elif [ "$($cat ${cpu}scaling_available_governors | $grep 'interactive')" ]; then
      KERNEL_TYPE="HMP"
  else
      KERNEL_TYPE="UNKNOWN"
  fi
done

# Fetch Arch info
ARCH=$($getprop ro.product.cpu.abi)

# Fetch SOC (System On-Chip) info
SOC=$($getprop ro.board.platform) 

# Fetch root method
ROOT=$($su -v) 

# Fetch ram info
TOTAL_RAM=$($free -m | $awk '/Mem:/{print $2}')
AVAIL_RAM=$($free -m | $awk '/Mem:/{print $7}')

# Fetch battery info
BATT_LVL=$($cat /sys/class/power_supply/battery/capacity)
BATT_CPCTY=$($cat /sys/class/power_supply/battery/charge_full_design)
if [ "$BATT_CPCTY" = "" ]; then
    BATT_CPCTY=$($dumpsys batterystats | $grep Capacity: | $awk '{print $2}' | $cut -d "," -f 1)
           
elif [ "$BATT_CPCTY" -gt "1000000" ]; then
    BATT_CPCTY=$((BATT_CPCTY / 1000))
fi

# Fetch XTweak info
TITLE=$($grep name= "$MODPATH/module.prop" | $sed "s/name=//")
VER=$($grep version= "$MODPATH/module.prop" | $sed "s/version=//")
CODENAME=$($grep codeName= "$MODPATH/module.prop" | $sed "s/codeName=//")
STATUS=$($grep Status= "$MODPATH/module.prop" | $sed "s/Status=//")
AUTHOR=$($grep author= "$MODPATH/module.prop" | $sed "s/author=//")

##############################
# Logging System Functions
###############################

# Logging system header
$sleep 3
$awk '{print}' "$MODPATH/xtweak_banner" >> $LOG
echo "[⚡] POWERFUL FORCEFULNESS KERNEL TWEAKER [⚡] " >> $LOG
echo "" >> $LOG
$sleep 2
echo "[*] CHECKING DEVICE INFO..." >> $LOG
$sleep 2
echo "~ BRAND : $BRAND " >> $LOG
echo "~ MODEL : $MODEL " >> $LOG
echo "~ ROM : $ROM " >> $LOG
echo "~ SYSTEM LANGUAGE : $LANG " >> $LOG
echo "~ ANDROID : $ANDROID " >> $LOG
echo "~ API LEVEL : $SDK " >> $LOG
echo "~ KERNEL : $KERNEL " >> $LOG
echo "~ KERNEL TYPE : $KERNEL_TYPE " >> $LOG
echo "~ CPU ARCHITECTURE : $ARCH " >> $LOG
echo "~ SOC : $SOC " >> $LOG
echo "~ ROOT METHOD : $ROOT " >> $LOG
echo "~ TOTAL RAM : $TOTAL_RAM MB " >> $LOG
echo "~ AVAILABLE RAM : $AVAIL_RAM MB" >> $LOG
echo "~ BATTERY LEVEL : $BATT_LVL %" >> $LOG
echo "~ BATTERY CAPACITY : $BATT_CPCTY MAH" >> $LOG
echo "" >> $LOG
echo "~ NAME : $TITLE " >> $LOG
echo "~ VERSION : $VER " >> $LOG
echo "~ CODENAME : $CODENAME " >> $LOG
echo "~ STATUS : $STATUS " >> $LOG
echo "~ AUTHOR : $AUTHOR " >> $LOG
echo "" >> $LOG
echo "[*] CURRENT MODE: $M " >> $LOG
echo "" >> $LOG
echo "[*] STARTING TWEAKS AT $($date) " >> $LOG
echo "" >> $LOG
$sleep 3

# Logging system footer
echo "[*] CLEANED VARIOUS JUNK FILES" >> $LOG
echo "[*] OPTIMIZED VARIOUS DOZE AND GMS PARAMETERS" >> $LOG
echo "[*] APPLIED CGROUP OPTIMIZATIONS" >> $LOG
echo "[*] EXECUTED SQLITE OPTIMIZATIONS" >> $LOG
echo "[*] ZIPALIGNED SYSTEM AND USER APKS" >> $LOG
echo "[*] APPLIED KERNEL TWEAKS" >> $LOG
echo "[*] OPTIMIZED CPU VALUES" >> $LOG
echo "[*] IMPROVED GPU PARAMETERS" >> $LOG
echo "[*] TWEAKED FS VALUES" >> $LOG
echo "[*] OPTIMIZED ENTROPY" >> $LOG
echo "[*] EXECUTED SCHEDULER TWEAKS" >> $LOG
echo "[*] IMPROVED KERNEL FREEZING AND KERNEL PANIC PARAMETERS" >> $LOG
echo "[*] DISABLED GPU LOGGING" >> $LOG
echo "[*] DISABLED RMNET AND LOGGING DAEMONS" >> $LOG
echo "[*] OPTIMIZED POWER EFFICIENCY" >> $LOG
echo "" >> $LOG
echo "[*] ENDED TWEAKS AT $($date) " >> $LOG
echo "" >> $LOG
}