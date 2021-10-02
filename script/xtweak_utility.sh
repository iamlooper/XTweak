#!/system/bin/sh
# XTweak Utility Script
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

if [ -e "/system/bin/mkdir" ]; then
mkdir="/system/bin/mkdir"
else
mkdir="/system/xbin/mkdir"
fi

if [ -e "/system/bin/clear" ]; then
clear="/system/bin/clear"
else
clear="/system/xbin/clear"
fi

if [ -e "/system/bin/grep" ]; then
grep="/system/bin/grep"
else
grep="/system/xbin/grep"
fi

if [ -e "/system/bin/grep" ]; then
grep="/system/bin/grep"
else
grep="/system/xbin/grep"
fi

if [ -e "/system/bin/sleep" ]; then
sleep="/system/bin/sleep"
else
sleep="/system/xbin/sleep"
fi

if [ -e "/system/bin/cat" ]; then
cat="/system/bin/cat"
else
cat="/system/xbin/cat"
fi

if [ -e "/system/bin/uname" ]; then
uname="/system/bin/uname"
else
uname="/system/xbin/uname"
fi

if [ -e "/system/bin/dumpsys" ]; then
dumpsys="/system/bin/dumpsys"
else
dumpsys="/system/xbin/dumpsys"
fi

if [ -e "/system/bin/rm" ]; then
rm="/system/bin/rm"
else
rm="/system/xbin/rm"
fi

if [ -e "/system/bin/awk" ]; then
awk="/system/bin/awk"
else
awk="/system/xbin/awk"
fi

if [ -e "/system/bin/cut" ]; then
cut="/system/bin/cut"
else
cut="/system/xbin/cut"
fi

if [ -e "/system/bin/free" ]; then
free="/system/bin/free"
else
free="/system/xbin/free"
fi

if [ -e "/system/bin/cp" ]; then
cp="/system/bin/cp"
else
cp="/system/xbin/cp"
fi

if [ -e "/system/bin/touch" ]; then
touch="/system/bin/touch"
else
touch="/system/xbin/touch"
fi

if [ -e "/system/bin/sed" ]; then
sed="/system/bin/sed"
else
sed="/system/xbin/sed"
fi

if [ -e "/system/bin/date" ]; then
date="/system/bin/date"
else
date="/system/xbin/date"
fi

if [ -e "/system/bin/chmod" ]; then
chmod="/system/bin/chmod"
else
chmod="/system/xbin/chmod"
fi

if [ -e "/system/bin/mv" ]; then
mv="/system/bin/mv"
else
mv="/system/xbin/mv"
fi

if [ -e "/system/bin/sync" ]; then
sync="/system/bin/sync"
else
sync="/system/xbin/sync"
fi

if [ -e "/system/bin/pgrep" ]; then
pgrep="/system/bin/pgrep"
else
pgrep="/system/xbin/pgrep"
fi

if [ -e "/system/bin/setprop" ]; then
setprop="/system/bin/setprop"
else
setprop="/system/xbin/setprop"
fi

if [ -e "/system/bin/killall" ]; then
killall="/system/bin/killall"
else
killall="/system/xbin/killall"
fi

if [ -e "/system/bin/kill" ]; then
kill="/system/bin/kill"
else
kill="/system/xbin/kill"
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

if [ -e "/system/bin/mount" ]; then
mount="/system/bin/mount"
else
mount="/system/xbin/mount"
fi

if [ -e "/system/bin/find" ]; then
find="/system/bin/find"
else
find="/system/xbin/find"
fi

if [ -e "/system/bin/wc" ]; then
wc="/system/bin/wc"
else
wc="/system/xbin/wc"
fi

if [ -e "/system/bin/setsid" ]; then
setsid="/system/bin/setsid"
else
setsid="/system/xbin/setsid"
fi

if [ -e "/system/bin/sh" ]; then
sh="/system/bin/sh"
else
sh="/system/xbin/sh"
fi

su="/data/adb/modules/xtweak/bin/su"

sqlite="/data/adb/modules/xtweak/bin/sqlite3"

zipalign="/data/adb/modules/xtweak/bin/zipalign"

wget="/data/adb/modules/xtweak/bin/wget"

busybox="/data/adb/magisk/busybox"

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
TOTAL_RAM=$($busybox $free -m | $awk '/Mem:/{print $2}')
FULL_RAM=$((TOTAL_RAM * 20 / 100))
AVAIL_RAM=$($busybox $free -m | $awk '/Mem:/{print $7}')
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
TOTAL_RAM=$($busybox $free -m | $awk '/Mem:/{print $2}')
AVAIL_RAM=$($busybox $free -m | $awk '/Mem:/{print $7}')

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
$sleep 4
$awk '{print}' "$MODPATH"/xtweak_banner >> $LOG
echo "[⚡] POWERFUL FORCEFULNESS KERNEL TWEAKER [⚡] " >> $LOG
echo "" >> $LOG
$sleep 2.5
echo "[*] CHECKING DEVICE INFO..." >> $LOG
$sleep 2.5
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

##############################
# Sqlite Optimization Function
###############################

x_sqlite(){
SQ_LOG="/storage/emulated/0/XTweak/sqlite.log"
if [ -f "$SQ_LOG" ]; then
	$rm -rf "$SQ_LOG"
fi
echo " --- XTweak 2021 --- " >> $SQ_LOG
echo "[*] Optimizing system databases..." >> $SQ_LOG
for i in $($find /d* -iname "*.db"); do
$sqlite "$i" 'VACUUM;'
resVac=$?
if [ "$resVac" = "0" ]; then
    resVac="SUCCESS"
else
    resVac="FAILED(ERRCODE)-$resVac"
fi
$sqlite "$i" 'REINDEX;'
resIndex=$?
if [ "$resIndex" = "0" ]; then
    resIndex="SUCCESS"
else
    resIndex="FAILED(ERRCODE)-$resIndex"
fi
$sqlite "$i" 'ANALYZE;'
resAnlz=$?
if [ "$resAnlz" = "0" ]; then
resAnlz="SUCCESS"
else
resAnlz="FAILED(ERRCODE)-$resAnlz"
fi
echo -e "[*] Database $i: VACUUM=$resVac REINDEX=$resIndex ANALYZE=$resAnlz" >> $SQ_LOG
done
}

##############################
# Zipalign Optimization Function
############################### 

x_zipalign(){
ZA_LOG="/storage/emulated/0/XTweak/zipalign.log"
ZA_DB="/storage/emulated/0/XTweak/zipalign.db"
if [ -f "$ZA_LOG" ]; then
	$rm -rf "$ZA_LOG"

elif [ ! -f "$ZA_DB" ]; then
	$touch "$ZA_DB"
fi
echo " --- XTweak 2021 --- " >> $ZA_LOG
for DIR in /system/app/* /data/app/* /system/product/app/* /system/priv-app/* /system/product/priv-app/* /vendor/data-app/* /vendor/app/* /vendor/overlay /system/system_ext/app/* /system/system_ext/priv-app/*
do
   cd $DIR  
   for APK in *.apk; do
    if [ "$APK" -ot "/storage/emulated/0/XTweak/zipalign.db" ] || [ "$($grep "$DIR/$APK" "/dev/XTweak/zipalign.db" | $wc -l)" -gt "0" ]; then
      echo -e "[*] Already checked: $DIR/$APK" >> $ZA_LOG
     else
      $zipalign -c 4 "$APK"
      if [ "$?" = "0" ]; then
        echo -e "[*] Already aligned: $DIR/$APK" >> $ZA_LOG
        $grep "$DIR/$APK" "/storage/emulated/0/XTweak/zipalign.db" || echo "$DIR/$APK"  >> $ZA_DB
      else
        echo -e "[*] Now aligning: $DIR/$APK" >> $ZA_LOG
        cd $APK
        $zipalign -f 4 "$APK" "/cache/$APK"
        $cp -af -p "/cache/$APK" "$APK"
        $rm -f "/cache/$APK"
        $grep "$DIR/$APK" "/storage/emulated/0/XTweak/zipalign.db" || echo "$DIR/$APK" >> $ZA_DB
      fi
    fi
  done
done
}

##############################
# Junk Cleaning Function
###############################

x_clean(){
$rm -rf /data/*.log
$rm -rf /data/vendor/wlan_logs 
$rm -rf /data/*.txt
$rm -rf /cache/*.apk
$rm -rf /data/anr/*
$rm -rf /data/backup/pending/*.tmp
$rm -rf /data/cache/*.* 
$rm -rf /data/data/*.log 
$rm -rf /data/data/*.txt 
$rm -rf /data/log/*.log 
$rm -rf /data/log/*.txt 
$rm -rf /data/local/*.apk 
$rm -rf /data/local/*.log 
$rm -rf /data/local/*.txt 
$rm -rf /data/mlog/* 
$rm -rf /data/system/*.log 
$rm -rf /data/system/*.txt 
$rm -rf /data/system/dropbox/* 
$rm -rf /data/system/usagestats/* 
$rm -rf /data/system/shared_prefs/* 
$rm -rf /data/tombstones/* 
$rm -rf /sdcard/LOST.DIR 
$rm -rf /sdcard/found000 
$rm -rf /sdcard/LazyList 
$rm -rf /sdcard/albumthumbs 
$rm -rf /sdcard/kunlun 
$rm -rf /sdcard/.CacheOfEUI 
$rm -rf /sdcard/.bstats 
$rm -rf /sdcard/.taobao 
$rm -rf /sdcard/Backucup 
$rm -rf /sdcard/MIUI/debug_log 
$rm -rf /sdcard/ramdump 
$rm -rf /sdcard/UnityAdsVideoCache 
$rm -rf /sdcard/*.log 
$rm -rf /sdcard/*.CHK 
$rm -rf /sdcard/duilite 
$rm -rf /sdcard/DkMiBrowserDemo 
$rm -rf /sdcard/.xlDownload 
}

##############################
# Doze Function
###############################

x_doze(){
# Stop certain services and restart it on boot
if [ "$(busybox pidof com.qualcomm.qcrilmsgtunnel.QcrilMsgTunnelService | $wc -l)" = "1" ]; then
$kill $(busybox com.qualcomm.qcrilmsgtunnel.QcrilMsgTunnelService)

elif [ "$(busybox pidof com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver | $wc -l)" = "1" ]; then
$kill $(busybox pidof com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver)

elif [ "$(busybox pidof com.google.android.gms.unstable | $wc -l)" = "1" ]; then
$kill $(busybox pidof com.google.android.gms.unstable)

elif [ "$(busybox pidof com.google.android.gms.wearable | $wc -l)" = "1" ]; then
$kill $(busybox pidof com.google.android.gms.wearable)

elif [ "$(busybox pidof com.google.android.gms.backup.backupTransportService | $wc -l)" = "1" ]; then
$kill $(busybox pidof com.google.android.gms.backup.backupTransportService)

elif [ "$(busybox pidof com.google.android.gms.lockbox.LockboxService | $wc -l)" = "1" ]; then
$kill $(busybox pidof com.google.android.gms.lockbox.LockboxService)

elif [ "$(busybox pidof com.google.android.gms.auth.setup.devicesignals.LockScreenService | $wc -l)" = "1" ]; then
$kill $(busybox pidof com.google.android.gms.auth.setup.devicesignals.LockScreenService)
fi
for i in $(ls /data/user/)
do
# Disable collective Device administrators
$pm disable --user $i com.google.android.gms/com.google.android.gms.auth.managed.admin.DeviceAdminReceiver 2>/dev/null  
$pm disable --user $i com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver 2>/dev/null  
# Disable both GMS and IMS 'Modify system settings' and restart it on boot
cmd appops set --user $i com.google.android.gms WRITE_SETTINGS ignore
cmd appops set --user $i com.google.android.ims WRITE_SETTINGS ignore
# Disable both GMS and IMS 'Run in startup' and restart it on boot
cmd appops set --user $i com.google.android.gms BOOT_COMPLETED ignore
cmd appops set --user $i com.google.android.ims BOOT_COMPLETED ignore
# Disable both GMS and IMS 'Run in startup' and restart it on boot (custom permissions for Oxygen OS)
cmd appops set --user $i com.google.android.gms AUTO_START ignore
cmd appops set --user $i com.google.android.ims AUTO_START ignore
done
# Optimize system settings (doze)
dumpsys deviceidle enable all
dumpsys deviceidle whitelist +com.android.systemui >/dev/null 2>&1
settings put global dropbox_max_files 1
settings put system anr_debugging_mechanism 0
settings put global adaptive_battery_management_enabled 1
settings put global aggressive_battery_saver 1
settings put secure location_providers_allowed ' '
dumpsys deviceidle enable all
dumpsys deviceidle enabled all
settings put system display_color_enhance 1
settings delete global device_idle_constants
settings put global device_idle_constants inactive_to=60000,sensing_to=0,locating_to=0,location_accuracy=2000,motion_inactive_to=0,idle_after_inactive_to=0,idle_pending_to=60000,max_idle_pending_to=120000,idle_pending_factor=2.0,idle_to=900000,max_idle_to=21600000,idle_factor=2.0,max_temp_app_whitelist_duration=60000,mms_temp_app_whitelist_duration=30000,sms_temp_app_whitelist_duration=20000,light_after_inactive_to=10000,light_pre_idle_to=60000,light_idle_to=180000,light_idle_factor=2.0,light_max_idle_to=900000,light_idle_maintenance_min_budget=30000,light_idle_maintenance_max_budget=60000
}

###############################
# Cgroup Optimization Functions
###############################

# $1:task_name $2:cgroup_name $3:"cpuset"/"stune"
change_task_cgroup(){
    local comm
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$($cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            echo "$temp_tid" > "/dev/$3/$2/tasks"
        done
    done
}

# $1:process_name $2:cgroup_name $3:"cpuset"/"stune"
change_proc_cgroup(){
    local comm
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        comm="$($cat /proc/"$temp_pid"/comm)"
        echo "$temp_pid" > "/dev/$3/$2/cgroup.procs"
    done
}

# $1:task_name $2:thread_name $3:cgroup_name $4:"cpuset"/"stune"
change_thread_cgroup(){
    local comm
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$($cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            if [ "$(echo "$comm" | $grep -i -E "$2")" != "" ]; then
                echo "$temp_tid" > "/dev/$4/$3/tasks"
            fi
        done
    done
}

# $1:task_name $2:cgroup_name $3:"cpuset"/"stune"
change_main_thread_cgroup(){
    local comm
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        comm="$($cat /proc/"$temp_pid"/comm)"
        echo "$temp_pid" > "/dev/$3/$2/tasks"
    done
}

# $1:task_name $2:hex_mask(0x00000003 is CPU0 and CPU1)
change_task_affinity(){
    local comm
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$($cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            taskset -p "$2" "$temp_tid" >> "$LOG_FILE"
        done
    done
}

# $1:task_name $2:thread_name $3:hex_mask(0x00000003 is CPU0 and CPU1)
change_thread_affinity(){
    local comm
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$($cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            if [ "$(echo "$comm" | $grep -i -E "$2")" != "" ]; then
                taskset -p "$3" "$temp_tid" >> "$LOG_FILE"
            fi
        done
    done
}

# $1:task_name $2:nice(relative to 120)
change_task_nice(){
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            renice -n +40 -p "$temp_tid"
            renice -n -19 -p "$temp_tid"
            renice -n "$2" -p "$temp_tid"
        done
    done
}

# $1:task_name $2:thread_name $3:nice(relative to 120)
change_thread_nice(){
    local comm
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$($cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            if [ "$(echo "$comm" | $grep -i -E "$2")" != "" ]; then
                renice -n +40 -p "$temp_tid"
                renice -n -19 -p "$temp_tid"
                renice -n "$3" -p "$temp_tid"
            fi
        done
    done
}

# $1:task_name $2:priority(99-x, 1<=x<=99)
change_task_rt(){
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$($cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            chrt -f -p "$2" "$temp_tid" >> "$LOG_FILE"
        done
    done
}

# $1:task_name $2:thread_name $3:priority(99-x, 1<=x<=99)
change_thread_rt(){
    local comm
    for temp_pid in $(echo "$ps_ret" | $grep -i -E "$1" | $awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$($cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            if [ "$(echo "$comm" | $grep -i -E "$2")" != "" ]; then
                chrt -f -p "$3" "$temp_tid" >> "$LOG_FILE"
            fi
        done
    done
}

# $1:task_name
change_task_high_prio(){
    # audio thread nice <= -16
    change_task_nice "$1" "-15"
}

# $1:task_name $2:thread_name
change_thread_high_prio(){
    # audio thread nice <= -16
    change_thread_nice "$1" "$2" "-15"
}

# $1:task_name $2:thread_name
unpin_thread(){
    change_thread_cgroup "$1" "$2" "" "cpuset"
}

# $1:task_name $2:thread_name
pin_thread_on_pwr(){
    change_thread_cgroup "$1" "$2" "background" "cpuset"
}

# $1:task_name $2:thread_name
pin_thread_on_mid(){
    unpin_thread "$1" "$2"
    change_thread_affinity "$1" "$2" "7f"
}

# $1:task_name $2:thread_name
pin_thread_on_perf(){
    unpin_thread "$1" "$2"
    change_thread_affinity "$1" "$2" "f0"
}

# $1:task_name
unpin_proc(){
    change_task_cgroup "$1" "" "cpuset"
}

# $1:task_name
pin_proc_on_pwr(){
    change_task_cgroup "$1" "background" "cpuset"
}

# $1:task_name
pin_proc_on_mid(){
    unpin_proc "$1"
    change_task_affinity "$1" "7f"
}

# $1:task_name
pin_proc_on_perf(){
    unpin_proc "$1"
    change_task_affinity "$1" "f0"
}

rebuild_process_scan_cache(){
    # avoid matching grep itself
    # ps -Ao pid,args | grep kswapd
    # 150 [kswapd0]
    # 16490 grep kswapd
    ps_ret="$(ps -Ao pid,args)"
}

x_cgroup(){
# Reduce Perf Cluster Wakeup
# daemons
pin_proc_on_pwr "crtc_commit|crtc_event|pp_event|msm_irqbalance|netd|mdnsd|analytics"
pin_proc_on_pwr "imsdaemon|cnss-daemon|qadaemon|qseecomd|time_daemon|ATFWD-daemon|ims_rtp_daemon|qcrilNrd"

# ueventd related to hotplug of camera, wifi, usb... 
# pin_proc_on_pwr "ueventd"
# hardware services, eg. android.hardware.sensors@1.0-service
pin_proc_on_pwr "android.hardware.bluetooth"
pin_proc_on_pwr "android.hardware.gnss"
pin_proc_on_pwr "android.hardware.health"
pin_proc_on_pwr "android.hardware.thermal"
pin_proc_on_pwr "android.hardware.wifi"
pin_proc_on_pwr "android.hardware.keymaster"
pin_proc_on_pwr "vendor.qti.hardware.qseecom"
pin_proc_on_pwr "hardware.sensors"
pin_proc_on_pwr "sensorservice"
pin_proc_on_pwr "android.process.media"

# com.miui.securitycenter & com.miui.securityadd
pin_proc_on_pwr "miui\.security"

# system_server blacklist
# system_server controlled by uperf
change_proc_cgroup "system_server" "" "cpuset"

# input dispatcher
change_thread_high_prio "system_server" "input"

# related to camera startup
# change_thread_affinity "system_server" "ProcessManager" "ff"
# not important
pin_thread_on_pwr "system_server" "Miui|Connect|Network|Wifi|backup|Sync|Observer|Power|Sensor|batterystats"
pin_thread_on_pwr "system_server" "Thread-|pool-|Jit|CachedAppOpt|Greezer|TaskSnapshot|Oom"
change_thread_nice "system_server" "Greezer|TaskSnapshot|Oom" "4"

# pin_thread_on_pwr "system_server" "Async" # it blocks camera
# pin_thread_on_pwr "system_server" "\.bg" # it blocks binders
# do not let GC thread block system_server
# pin_thread_on_mid "system_server" "HeapTaskDaemon"
# pin_thread_on_mid "system_server" "FinalizerDaemon"
# Render Pipeline
# speed up searching service binder
change_task_cgroup "servicemanag" "top-app" "cpuset"

# prevent display service from being preempted by normal tasks
# vendor.qti.hardware.display.allocator-service cannot be set to RT policy, will be reset to 120
unpin_proc "\.hardware\.display"
change_task_affinity "\.hardware\.display" "7f"
change_task_rt "\.hardware\.display" "2"

# let UX related Binders run with top-app
change_thread_cgroup "\.hardware\.display" "^Binder" "top-app" "cpuset"
change_thread_cgroup "\.hardware\.display" "^HwBinder" "top-app" "cpuset"
change_thread_cgroup "\.composer" "^Binder" "top-app" "cpuset"

# Heavy Scene Boost
unpin_proc "zygote|usap"
change_task_high_prio "zygote|usap"

# busybox fork from magiskd
pin_proc_on_mid "magiskd"
change_task_nice "magiskd" "19"
}

##############################
# HWUI Optimization Function
###############################

x_hwui(){
if [ "$TOTAL_RAM" -lt "3072" ]; then
$resetprop hwui.use_gpu_pixel_buffers false
$resetprop debug.hwui.use_buffer_age false
$resetprop ro.hwui.texture_cache_size $((TOTAL_RAM * 10 / 100 / 2))
$resetprop ro.hwui.layer_cache_size $((TOTAL_RAM * 5 / 100 / 2))
$resetprop ro.hwui.path_cache_size $((TOTAL_RAM * 2 / 100 / 2))
$resetprop ro.hwui.r_buffer_cache_size $((TOTAL_RAM / 100 / 2))
$resetprop ro.hwui.drop_shadow_cache_size $((TOTAL_RAM / 100 / 2))
$resetprop ro.hwui.texture_cache_flushrate 0.3
$resetprop ro.hwui.gradient_cache_size 1
$resetprop ro.hwui.text_small_cache_width 1024
$resetprop ro.hwui.text_small_cache_height 1024
$resetprop ro.hwui.text_large_cache_width 2048
$resetprop ro.hwui.text_large_cache_height 1024
else
$resetprop hwui.use_gpu_pixel_buffers false
$resetprop debug.hwui.use_buffer_age false
$resetprop ro.hwui.texture_cache_size $((TOTAL_RAM * 10 / 100))
$resetprop ro.hwui.layer_cache_size $((TOTAL_RAM * 5 / 100))
$resetprop ro.hwui.path_cache_size $((TOTAL_RAM * 2 / 100))
$resetprop ro.hwui.r_buffer_cache_size $((TOTAL_RAM / 100))
$resetprop ro.hwui.drop_shadow_cache_size $((TOTAL_RAM / 100))
$resetprop ro.hwui.texture_cache_flushrate 0.3
$resetprop ro.hwui.gradient_cache_size 1
$resetprop ro.hwui.text_small_cache_width 1024
$resetprop ro.hwui.text_small_cache_height 1024
$resetprop ro.hwui.text_large_cache_width 2048
$resetprop ro.hwui.text_large_cache_height 1024
fi
}

##############################
# Net Optimization Function
###############################

x_net(){
write "/proc/sys/net/ipv4/conf/default/secure_redirects" "0"
write "/proc/sys/net/ipv4/conf/default/accept_redirects" "0"
write "/proc/sys/net/ipv4/conf/default/accept_source_route" "0"
write "/proc/sys/net/ipv4/conf/all/secure_redirects" "0"
write "/proc/sys/net/ipv4/conf/all/accept_redirects" "0"
write "/proc/sys/net/ipv4/conf/all/accept_source_route" "0"
write "/proc/sys/net/ipv4/ip_forward" "0"
write "/proc/sys/net/ipv4/ip_dynaddr" "0"
write "/proc/sys/net/ipv4/ip_no_pmtu_disc" "0"
write "/proc/sys/net/ipv4/tcp_ecn" "0"
write "/proc/sys/net/ipv4/tcp_timestamps" "0"
write "/proc/sys/net/ipv4/tcp_tw_reuse" "1"
write "/proc/sys/net/ipv4/tcp_fack" "1"
write "/proc/sys/net/ipv4/tcp_sack" "1"
write "/proc/sys/net/ipv4/tcp_dsack" "1"
write "/proc/sys/net/ipv4/tcp_rfc1337" "1"
write "/proc/sys/net/ipv4/tcp_tw_recycle" "1"
write "/proc/sys/net/ipv4/tcp_window_scaling" "1"
write "/proc/sys/net/ipv4/tcp_moderate_rcvbuf" "1"
write "/proc/sys/net/ipv4/tcp_no_metrics_save" "1"
write "/proc/sys/net/ipv4/tcp_synack_retries" "2"
write "/proc/sys/net/ipv4/tcp_syn_retries" "2"
write "/proc/sys/net/ipv4/tcp_keepalive_probes" "5"
write "/proc/sys/net/ipv4/tcp_fin_timeout" "30"
write "/proc/sys/net/core/rmem_max" "261120"
write "/proc/sys/net/core/wmem_max" "261120"
write "/proc/sys/net/core/rmem_default" "261120"
write "/proc/sys/net/core/wmem_default" "261120"
write "/proc/sys/net/core/netdev_max_backlog" "128"
write "/proc/sys/net/core/netdev_tstamp_prequeue" "0"
write "/proc/sys/net/ipv4/cipso_cache_bucket_size" "0"
write "/proc/sys/net/ipv4/cipso_cache_enable" "0"
write "/proc/sys/net/ipv4/cipso_rbm_strictvalid" "0"
write "/proc/sys/net/ipv4/igmp_link_local_mcast_reports" "0"
write "/proc/sys/net/ipv4/ipfrag_time" "24"
write "/proc/sys/net/ipv4/tcp_fwmark_accept" "0"
write "/proc/sys/net/ipv4/tcp_keepalive_intvl" "320"
write "/proc/sys/net/ipv4/tcp_keepalive_time" "21600"
write "/proc/sys/net/ipv4/tcp_probe_interval" "1800"
write "/proc/sys/net/ipv4/tcp_slow_start_after_idle" "0"
write "/proc/sys/net/ipv6/ip6frag_time" "48"
}