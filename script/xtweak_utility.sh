#!/system/bin/bash
# XTweak Utility Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

_getprop(){
if [[ -e "/system/bin/getprop" ]]; then
/system/bin/getprop "$@"
else
/system/xbin/getprop "$@"
fi
}

_mkdir(){
if [[ -e "/system/bin/mkdir" ]]; then
/system/bin/mkdir "$@"
else
/system/xbin/mkdir "$@"
fi
}

_clear(){
if [[ -e "/system/bin/clear" ]]; then
/system/bin/clear "$@"
else
/system/xbin/clear "$@"
fi
}

_grep(){
if [[ -e "/system/bin/grep" ]]; then
/system/bin/grep "$@"
else
/system/xbin/grep "$@"
fi
}

_sleep(){
if [[ -e "/system/bin/sleep" ]]; then
/system/bin/sleep "$@"
else
/system/xbin/sleep "$@"
fi
}

_cat(){
if [[ -e "/system/bin/cat" ]]; then
/system/bin/cat "$@"
else
/system/xbin/cat "$@"
fi
}

_uname(){
if [[ -e "/system/bin/uname" ]]; then
/system/bin/uname "$@"
else
/system/xbin/uname "$@"
fi
}

_su(){
/data/adb/modules/xtweak/bin/su "$@"
}

_dumpsys(){
if [[ -e "/system/bin/dumpsys" ]]; then
/system/bin/dumpsys "$@"
else
/system/xbin/dumpsys "$@"
fi
}

_rm(){
if [[ -e "/system/bin/rm"  ]]; then
/system/bin/rm "$@"
else
/system/xbin/rm "$@"
fi
}

_awk(){
if [[ -e "/system/bin/awk" ]]; then
/system/bin/awk "$@"
else
/system/xbin/awk "$@"
fi
}

_cut(){
if [[ -e "/system/bin/cut" ]]; then
/system/bin/cut "$@"
else
/system/xbin/cut "$@"
fi
}

_free(){
if [[ -e "/system/bin/free" ]]; then
/system/bin/free "$@"
else
/system/xbin/free "$@"
fi
}

_cp(){
if [[ -e "/system/bin/cp" ]]; then
/system/bin/cp "$@"
else
/system/xbin/cp "$@"
fi
}

_touch(){
if [[ -e "/system/bin/touch" ]]; then
/system/bin/touch "$@"
else
/system/xbin/touch "$@"
fi
}

_sed(){
if [[ -e "/system/bin/sed" ]]; then
/system/bin/sed "$@"
else
/system/xbin/sed "$@"
fi
}

_date(){
if [[ -e "/system/bin/date" ]]; then
/system/bin/date "$@"
else
/system/xbin/date "$@"
fi
}

_chmod(){
if [[ -e "/system/bin/chmod" ]]; then
/system/bin/chmod "$@"
else
/system/xbin/chmod "$@"
fi
}

_mv(){
if [[ -e "/system/bin/mv" ]]; then
/system/bin/mv "$@"
else
/system/xbin/mv "$@"
fi
}

_sync(){
if [[ -e "/system/bin/sync" ]]; then
/system/bin/sync "$@"
else
/system/xbin/sync "$@"
fi
}

_pgrep(){
if [[ -e "/system/bin/pgrep" ]]; then
/system/bin/pgrep "$@"
else
/system/xbin/pgrep "$@"
fi
}

_setprop(){
if [[ -e "/system/bin/setprop" ]]; then
/system/bin/setprop "$@"
else
/system/xbin/setprop "$@"
fi
}

_killall(){
if [[ -e "/system/bin/killall" ]]; then
/system/bin/killall "$@"
else
/system/xbin/killall"$@"
fi
}

_kill(){
if [[ -e "/system/bin/kill" ]]; then
/system/bin/kill "$@"
else
/system/xbin/kill "$@"
fi
}

_bash(){
if [[ -e "/system/bin/bash" ]]; then
/system/bin/bash "$@"
else
/system/xbin/bash "$@"
fi
}

_am(){
if [[ -e "/system/bin/am" ]]; then
/system/bin/am "$@"
else
/system/xbin/am "$@"
fi
}

_pm(){
if [[ -e "/system/bin/pm" ]]; then
/system/bin/pm "$@"
else
/system/xbin/pm "$@"
fi
}

_sqlite3(){
/data/adb/modules/xtweak/bin/sqlite3 "$@"
}

_zipalign(){
/data/adb/modules/xtweak/bin/zipalign "$@"
}

_mount(){
if [[ -e "/system/bin/mount" ]]; then
/system/bin/mount "$@"
else
/system/xbin/mount "$@"
fi
}

_find(){
if [[ -e "/system/bin/find" ]]; then
/system/bin/find "$@"
else
/system/xbin/find "$@"
fi
}

_wc(){
if [[ -e "/system/bin/wc" ]]; then
/system/bin/wc "$@"
else
/system/xbin/wc "$@"
fi
}

_busybox(){
/data/adb/modules/xtweak/bin/busybox "$@"
}

# Fetch ram info
_ram_info(){
TOTAL_RAM=$(_busybox _free -m | awk '/Mem:/{print $2}')
FULL_RAM=$((TOTAL_RAM * 20 / 100))
AVAIL_RAM=$(_busybox _free -m | _awk '/Mem:/{print $7}')
}

# Fetch battery status
_battery_status(){
if [[ -e "/sys/class/power_supply/battery/status" ]]; then
BATT_STATUS=$(_cat /sys/class/power_supply/battery/status)
            
else
BATT_STATUS=$(_dumpsys battery | _awk '/status/{print $2}')
fi
}

# Fetch battery level
_battery_percentage(){               
if [[ -e "/sys/class/power_supply/battery/capacity" ]]; then
BATT_LVL=$(_cat /sys/class/power_supply/battery/capacity)
                  
else
BATT_LVL=$(_dumpsys battery | _awk '/level/{print $2}')
fi
}

# Fetch screen state
_screen_state(){
SCRN_STATE=$(_dumpsys power | _grep state=O | _cut -d "=" -f 2)
if [[ "$scrn_state" == "ON" ]]; then 
SCRN_ON=1

else 
SCRN_ON=0
fi
}

logging_system(){

LOG="/storage/emulated/0/XTweak/xtweak.log"

# Clear logs before logging again
_rm -rf "$LOG"

# Fetch brand info
BRAND=$(_getprop ro.product.brand)

# Fetch device model info
MODEL=$(_getprop ro.product.model)

# Fetch ROM id
ROM=$(_getprop ro.build.display.id)

# Fetch system language info
LANG=$(_getprop persist.sys.locale) 

# Fetch android release version
ANDROID=$(_getprop ro.build.version.release)

# Fetch android sdk info
SDK=$(_getprop ro.build.version.sdk) 

# Fetch kernel related info
KERNEL=$(_uname -r)
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/
do
  if [[ "$(_cat $cpu/scaling_available_governors | _grep 'sched')" ]]; then
      KERNEL_TYPE="EAS"
  elif [[ "$(_cat $cpu/scaling_available_governors | _grep 'interactive')" ]]; then
      KERNEL_TYPE="HMP"
  else
      KERNEL TYPE="UNKNOWN"
  fi
done

# Fetch Arch info
ARCH=$(_getprop ro.product.cpu.abi)

# Fetch SOC (System On-Chip) info
SOC=$(_getprop ro.board.platform) 

# Fetch root method
ROOT=$(_su -v) 

# Fetch ram info
TOTAL_RAM=$(_free -m | _awk '/Mem:/{print $2}')
AVAIL_RAM=$(_free -m | _awk '/Mem:/{print $7}')

# Fetch battery info
BATT_LVL=$(_cat /sys/class/power_supply/battery/capacity)
BATT_CPCTY=$(_cat /sys/class/power_supply/battery/charge_full_design)
if [[ "$BATT_CPCTY" == "" ]]; then
    BATT_CPCTY=$(_dumpsys batterystats | _grep Capacity: | _awk '{print $2}' | _cut -d "," -f 1)
           
elif [[ "$BATT_CPCTY" -gt "1000000" ]]; then
    BATT_CPCTY=$((batt_cpct / 1000))
fi

# Fetch XTweak info
TITLE=$(_grep name= "$MODPATH/module.prop" | _sed "s/name=//")
VER=$(_grep version= "$MODPATH/module.prop" | _sed "s/version=//")
CODENAME=$(_grep codeName= "$MODPATH/module.prop" | _sed "s/codeName=//")
STATUS=$(_grep Status= "$MODPATH/module.prop" | _sed "s/Status=//")
AUTHOR=$(_grep author= "$MODPATH/module.prop" | _sed "s/author=//")

# Logging system header
_sleep 4
_awk '{print}' "$MODPATH"/xtweak_banner >> $LOG
echo "[⚡] POWERFUL FORCEFULNESS KERNEL TWEAKER [⚡] " >> $LOG
echo "" >> $LOG
_sleep 2.5
echo "[*] CHECKING DEVICE INFO..." >> $LOG
_sleep 2.5
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
echo "[*] STARTING TWEAKS AT $(_date) " >> $LOG
echo "" >> $LOG
_sleep 3

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
echo "[*] ENDED TWEAKS AT $(_date) " >> $LOG
echo "" >> $LOG
}

# SQLite optimization 
x_sqlite(){
SQ_LOG="/storage/emulated/0/XTweak/sqlite.log"
if [[ -f "$SQ_LOG" ]]; then
	_rm -rf "$SQ_LOG"
fi
echo " --- XTweak 2021 --- " >> $SQ_LOG
echo "[*] Optimizing system databases..." >> $SQ_LOG
for i in $(_find /d* -iname "*.db"); do
_sqlite3 "$i" 'VACUUM;'
resVac=$?
if [[ "$resVac" == "0" ]]; then
    resVac="SUCCESS"
else
    resVac="FAILED(ERRCODE)-$resVac"
fi
_sqlite3 "$i" 'REINDEX;'
resIndex=$?
if [[ "$resIndex" == "0" ]]; then
    resIndex="SUCCESS"
else
    resIndex="FAILED(ERRCODE)-$resIndex"
fi
_sqlite3 "$i" 'ANALYZE;'
resAnlz=$?
if [[ "$resAnlz" == "0" ]]; then
resAnlz="SUCCESS"
else
resAnlz="FAILED(ERRCODE)-$resAnlz"
fi
echo -e "[*] Database $i: VACUUM=$resVac REINDEX=$resIndex ANALYZE=$resAnlz" >> $SQ_LOG
done
}

# Zipalign optimization 
x_zipalign(){
ZA_LOG="/storage/emulated/0/XTweak/zipalign.log"
ZA_DB="/storage/emulated/0/XTweak/zipalign.db"
if [[ -f "$ZA_LOG" ]]; then
	_rm -rf "$ZA_LOG"

elif [[ ! -f "$ZA_DB" ]]; then
	_touch "$ZA_DB"
fi
echo " --- XTweak 2021 --- " >> $ZA_LOG
for DIR in /system/app/* /data/app/* /system/product/app/* /system/priv-app/* /system/product/priv-app/* /vendor/data-app/* /vendor/app/* /vendor/overlay /system/system_ext/app/* /system/system_ext/priv-app/*
do
   cd $DIR  
   for APK in *.apk; do
    if [[ "$APK" -ot "/storage/emulated/0/XTweak/zipalign.db" ]] || [[ "$(_grep "$DIR/$APK" "/dev/XTweak/zipalign.db" | _wc -l)" -gt "0" ]]; then
      echo -e "[*] Already checked: $DIR/$APK" >> $ZA_LOG
     else
      _zipalign -c 4 "$APK"
      if [[ "$?" == "0" ]]; then
        echo -e "[*] Already aligned: $DIR/$APK" >> $ZA_LOG
        _grep "$DIR/$APK" "/storage/emulated/0/XTweak/zipalign.db" || echo "$DIR/$APK"  >> $ZA_DB
      else
        echo -e "[*] Now aligning: $DIR/$APK" >> $ZA_LOG
        cd $APK
        _zipalign -f 4 "$APK" "/cache/$APK"
        _cp -af -p "/cache/$APK" "$APK"
        _rm -f "/cache/$APK"
        _grep "$DIR/$APK" "/storage/emulated/0/XTweak/zipalign.db" || echo "$DIR/$APK" >> $ZA_DB
      fi
    fi
  done
done
}

# Junk cleaning 
x_clean(){
_rm -rf /data/*.log
_rm -rf /data/vendor/wlan_logs 
_rm -rf /data/*.txt
_rm -rf /cache/*.apk
_rm -rf /data/anr/*
_rm -rf /data/backup/pending/*.tmp
_rm -rf /data/cache/*.* 
_rm -rf /data/data/*.log 
_rm -rf /data/data/*.txt 
_rm -rf /data/log/*.log 
_rm -rf /data/log/*.txt 
_rm -rf /data/local/*.apk 
_rm -rf /data/local/*.log 
_rm -rf /data/local/*.txt 
_rm -rf /data/mlog/* 
_rm -rf /data/system/*.log 
_rm -rf /data/system/*.txt 
_rm -rf /data/system/dropbox/* 
_rm -rf /data/system/usagestats/* 
_rm -rf /data/system/shared_prefs/* 
_rm -rf /data/tombstones/* 
_rm -rf /sdcard/LOST.DIR 
_rm -rf /sdcard/found000 
_rm -rf /sdcard/LazyList 
_rm -rf /sdcard/albumthumbs 
_rm -rf /sdcard/kunlun 
_rm -rf /sdcard/.CacheOfEUI 
_rm -rf /sdcard/.bstats 
_rm -rf /sdcard/.taobao 
_rm -rf /sdcard/Backucup 
_rm -rf /sdcard/MIUI/debug_log 
_rm -rf /sdcard/ramdump 
_rm -rf /sdcard/UnityAdsVideoCache 
_rm -rf /sdcard/*.log 
_rm -rf /sdcard/*.CHK 
_rm -rf /sdcard/duilite 
_rm -rf /sdcard/DkMiBrowserDemo 
_rm -rf /sdcard/.xlDownload 
}

# Doze
x_doze(){
# Stop certain services and restart it on boot
if [[ "$(busybox pidof com.qualcomm.qcrilmsgtunnel.QcrilMsgTunnelService | _wc -l)" == "1" ]]; then
_kill $(busybox com.qualcomm.qcrilmsgtunnel.QcrilMsgTunnelService)

elif [[ "$(busybox pidof com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver | _wc -l)" == "1" ]]; then
_kill $(busybox pidof com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver)

elif [[ "$(busybox pidof com.google.android.gms.unstable | _wc -l)" == "1" ]]; then
_kill $(busybox pidof com.google.android.gms.unstable)

elif [[ "$(busybox pidof com.google.android.gms.wearable | _wc -l)" == "1" ]]; then
_kill $(busybox pidof com.google.android.gms.wearable)

elif [[ "$(busybox pidof com.google.android.gms.backup.backupTransportService | _wc -l)" == "1" ]]; then
_kill $(busybox pidof com.google.android.gms.backup.backupTransportService)

elif [[ "$(busybox pidof com.google.android.gms.lockbox.LockboxService | _wc -l)" == "1" ]]; then
_kill $(busybox pidof com.google.android.gms.lockbox.LockboxService)

elif [[ "$(busybox pidof com.google.android.gms.auth.setup.devicesignals.LockScreenService | _wc -l)" == "1" ]]; then
_kill $(busybox pidof com.google.android.gms.auth.setup.devicesignals.LockScreenService)
fi
for i in $(ls /data/user/)
do
# Disable collective Device administrators
_pm disable --user $i com.google.android.gms/com.google.android.gms.auth.managed.admin.DeviceAdminReceiver 2>/dev/null  
_pm disable --user $i com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver 2>/dev/null  
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

# Cgroup optimization
# $1:task_name $2:cgroup_name $3:"cpuset"/"stune"
change_task_cgroup(){
    local comm
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$(cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            echo "$temp_tid" > "/dev/$3/$2/tasks"
        done
    done
}

# $1:process_name $2:cgroup_name $3:"cpuset"/"stune"
change_proc_cgroup(){
    local comm
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
        comm="$(cat /proc/"$temp_pid"/comm)"
        echo "$temp_pid" > "/dev/$3/$2/cgroup.procs"
    done
}

# $1:task_name $2:thread_name $3:cgroup_name $4:"cpuset"/"stune"
change_thread_cgroup(){
    local comm
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$(cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            if [ "$(echo "$comm" | grep -i -E "$2")" != "" ]; then
                echo "$temp_tid" > "/dev/$4/$3/tasks"
            fi
        done
    done
}

# $1:task_name $2:cgroup_name $3:"cpuset"/"stune"
change_main_thread_cgroup(){
    local comm
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
        comm="$(cat /proc/"$temp_pid"/comm)"
        echo "$temp_pid" > "/dev/$3/$2/tasks"
    done
}

# $1:task_name $2:hex_mask(0x00000003 is CPU0 and CPU1)
change_task_affinity(){
    local comm
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$(cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            taskset -p "$2" "$temp_tid" >> "$LOG_FILE"
        done
    done
}

# $1:task_name $2:thread_name $3:hex_mask(0x00000003 is CPU0 and CPU1)
change_thread_affinity(){
    local comm
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$(cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            if [ "$(echo "$comm" | grep -i -E "$2")" != "" ]; then
                taskset -p "$3" "$temp_tid" >> "$LOG_FILE"
            fi
        done
    done
}

# $1:task_name $2:nice(relative to 120)
change_task_nice(){
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
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
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$(cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            if [ "$(echo "$comm" | grep -i -E "$2")" != "" ]; then
                renice -n +40 -p "$temp_tid"
                renice -n -19 -p "$temp_tid"
                renice -n "$3" -p "$temp_tid"
            fi
        done
    done
}

# $1:task_name $2:priority(99-x, 1<=x<=99)
change_task_rt(){
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$(cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            chrt -f -p "$2" "$temp_tid" >> "$LOG_FILE"
        done
    done
}

# $1:task_name $2:thread_name $3:priority(99-x, 1<=x<=99)
change_thread_rt(){
    local comm
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$(cat /proc/"$temp_pid"/task/"$temp_tid"/comm)"
            if [ "$(echo "$comm" | grep -i -E "$2")" != "" ]; then
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