#!/system/bin/bash
# XTweak Potency Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

MODPATH="/data/adb/modules/xtweak"

# Load utility lib
source "${MODPATH}/script/xtweak_utility.sh"

# Main Variables
KERNEL="/proc/sys/kernel"
VM="/proc/sys/vm"
SCHED_FEATURES="/sys/kernel/debug/sched_features"
RAID="/proc/sys/dev/raid"
PTY="/proc/sys/kernel/pty"
KEYS="/proc/sys/kernel/keys"
FS="/proc/sys/fs"
LMK="/sys/module/lowmemorykiller/parameters"

write(){
	# Bail out if file does not exist
	[[ ! -f "$1" ]] && return 1

	# Make file read-able and write-able in case it is not already
	_chmod +rw "$1" 2>/dev/null

	# Write the new value and bail if there's an error
	if ! echo "$2" > "$1" 2>/dev/null
	then
		echo "[!] Failed: $1 → $2"
		return 1
	fi

	# Log the success
	echo "[*] $1 → $2"
}

# Always sync data
_sync 

# Kernel Tweaks
write "$KERNEL/perf_cpu_time_max_percent" "3"
write "$KERNEL/sched_autogroup_enabled" "1"
write "$KERNEL/sched_cfs_boost" "0"
write "$KERNEL/sched_child_runs_first" "1"
write "$KERNEL/sched_cstat_aware" "1"
write "$KERNEL/sched_tunable_scaling" "0"
write "$KERNEL/sched_latency_ns" "1000000"
write "$KERNEL/sched_migration_cost_ns" "5000000"
write "$KERNEL/sched_min_granularity_ns" "100000"
write "$KERNEL/sched_nr_migrate" "16"
write "$KERNEL/sched_rr_timeslice_ns" "100"
write "$KERNEL/sched_rt_period_us" "1000000"
write "$KERNEL/sched_rt_runtime_us" "950000"
write "$KERNEL/sched_shares_window_ns" "10000000"
write "$KERNEL/sched_sync_hint_enable" "1"
write "$KERNEL/sched_time_avg_ms" "1000"
write "$KERNEL/sched_tunable_scaling" "0"
write "$KERNEL/sched_use_walt_cpu_util" "1"
write "$KERNEL/sched_use_walt_task_util" "1"
write "$KERNEL/sched_wakeup_granularity_ns" "500000"
write "$KERNEL/sched_walt_cpu_high_irqload" "20000000"
write "$KERNEL/sched_walt_init_task_load_pct" "20"
write "$KERNEL/hung_task_timeout_secs" "0"
# VM (Virtual Machine) Tweaks
write "$VM/dirty_background_ratio" "6"
write "$VM/dirty_ratio" "30"
write "$VM/dirty_expire_centisecs" "3000"
write "$VM/dirty_writeback_centisecs" "3000"
write "$VM/page-cluster" "0"
write "$VM/reap_mem_on_sigkill" "1"
write "$VM/stat_interval" "5"
write "$VM/swappiness" "100"
write "$VM/overcommit_ratio" "30"
write "$VM/vfs_cache_pressure" "200"
write "$VM/extfrag_threshold" "750"
write "$VM/swap_ratio" "40"
write "$VM/drop_caches" "3"
write "$VM/breath_period" "0"
write "$VM/breath_priority" "-1001"
write "$VM/memory_plus" "0"

# CPU Tweaks
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/
do
    avail_govs="$(_cat "${cpu}scaling_available_governors")"
    if [[ "$avail_govs" == *"schedutil"* ]]
    then
        write "${cpu}scaling_governor" "schedutil"
        write "${cpu}schedutil/up_rate_limit_us" "0"
        write "${cpu}schedutil/down_rate_limit_us" "0"
        write "${cpu}schedutil/rate_limit_us" "0"
        write "${cpu}schedutil/hispeed_load" "85"
        write "${cpu}schedutil/hispeed_freq" "$(_cat "${cpu}cpuinfo_max_freq")"
    elif [[ "$avail_govs" == *"interactive"* ]]
    then
        write "${cpu}scaling_governor" "interactive"
        write "${cpu}interactive/timer_rate" "0"
        write "${cpu}interactive/min_sample_time" "0"
        write "${cpu}interactive/go_hispeed_load" "85"
        write "${cpu}interactive/hispeed_freq" "$(_cat "${cpu}cpuinfo_max_freq")"
    fi
done

# GPU Tweaks
write "/sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate" "1"
write "/sys/class/kgsl/kgsl-3d0/devfreq/polling_interval" "5"
write "/sys/class/kgsl/kgsl-3d0/idle_timer" "10000000"
write "/sys/class/kgsl/kgsl-3d0/force_clk_on" "1"
write "/sys/class/kgsl/kgsl-3d0/max_pwrlevel" "0"
write "/sys/class/kgsl/kgsl-3d0/default_pwrlevel" "0"
write "/sys/class/kgsl/kgsl-3d0/thermal_pwrlevel" "0"
write "/sys/class/kgsl/kgsl-3d0/force_bus_on" "1"
write "/sys/class/kgsl/kgsl-3d0/force_no_nap" "1"
write "/sys/class/kgsl/kgsl-3d0/force_rail_on" "1"
write "/sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost" "3"
write "/sys/devices/soc/kgsl-3d0/devfreq/kgsl-3d0/adrenoboost" "3"
write "/sys/class/kgsl/kgsl-3d0/bus_split" "0"
write "/sys/class/kgsl/kgsl-3d0/throttling" "0"

# Adreno Idler Tweaks
write "/sys/module/adreno_idler/parameters/adreno_idler_active" "Y"
write "/sys/module/adreno_idler/parameters/adreno_idler_downdifferential" "25"
write "/sys/module/adreno_idler/parameters/adreno_idler_idlewait" "15"
write "/sys/module/adreno_idler/parameters/adreno_idler_idleworkload" "5000"

# Tune sched_domain values for better latency and perf
for sched_domain in /proc/sys/kernel/sched_domain/cpu*/domain*/
do
write "${sched_domain}min_interval" "8"
write "${sched_domain}max_interval" "4"
write "${sched_domain}busy_factor" "32"
write "${sched_domain}busy_idx" "2"
write "${sched_domain}cache_nice_tries" "1"
write "${sched_domain}flags" "4143"
write "${sched_domain}forkexec_idx" "0"
write "${sched_domain}idle_idx" "1"
write "${sched_domain}imbalance_pct" "125"
write "${sched_domain}newidle_idx" "0"
write "${sched_domain}wake_idx" "0"
done

# Tune sched_features for overall userspace improvement 
write "$SCHED_FEATURES" "NO_NEXT_BUDDY"
write "$SCHED_FEATURES" "TTWU_QUEUE"
write "$SCHED_FEATURES" "NO_GENTLE_FAIR_SLEEPERS"
write "$SCHED_FEATURES" "NO_NEW_FAIR_SLEEPERS"
write "$SCHED_FEATURES" "ARCH_POWER"
write "$SCHED_FEATURES" "EAS_PREFER_IDLE"
write "$SCHED_FEATURES" "ENERGY_AWARE"
write "$SCHED_FEATURES" "NO_EAS_USE_NEED_IDLE"

# Enable UFS powersaving
for ufs in /sys/devices/soc/*/
do
write "${ufs}clkscale_enable" "0"
write "${ufs}clkgate_enable" "0"
write "${ufs}hibern8_on_idle_enable" "0"
done
write "/sys/module/lpm_levels/parameters/sleep_disabled" "Y"

# Multi-core powersaving
if [[ -e "/sys/devices/system/cpu/sched_mc_power_savings" ]]; then
write "/sys/devices/system/cpu/sched_mc_power_savings" "0"
fi

# Tune raid speed limit
write "$RAID/speed_limit_max" "14000"
write "$RAID/speed_limit_min" "7000"

# Tune pty tunables 
write "$PTY/max" "4096"
write "$PTY/min" "2048"

# Tune /proc/sys/kernel/keys/ tunables
write "$KEYS/gc_delay" "100"
write "$KEYS/maxbytes" "20000"
write "$KEYS/maxkeys" "200" 

# FS (File-System) Tweaks
write "$FS/leases-enable" "1"
write "$FS/lease-break-time" "7"
write "$FS/inotify/max_queued_events" "131072"
write "$FS/inotify/max_user_watches" "131072"
write "$FS/inotify/max_user_instances" "512"

# Blkio Tweaks
write "/dev/blkio/blkio.weight" "1000"
write "/dev/blkio/blkio.leaf_weight" "1000"
write "/dev/blkio/background/blkio.weight" "100"
write "/dev/blkio/background/blkio.leaf_weight" "100"

# Fstrim partitions
fstrim -v /cache 2>/dev/null
fstrim -v /data 2>/dev/null
fstrim -v /system 2>/dev/null

# App launch boost tweak
write "/sys/module/boost_control/parameters/app_launch_boost_ms" "500"

# Input and Stune Boost Tweaks
write "/sys/module/cpu_boost/parameters/dynamic_stune_boost" "15"
write "/sys/module/cpu_boost/parameters/dynamic_stune_boost_ms" "500"
write "/sys/module/cpu_boost/parameters/input_boost_freq" "0"
write "/sys/module/cpu_boost/parameters/input_boost_ms" "0"

# Uclamp Tweaks
write "/proc/sys/kernel/sched_util_clamp_min" "128"
write "/proc/sys/kernel/sched_util_clamp_min_rt_default" "128"
write "/dev/cpuset/top-app/uclamp.max" "min"
write "/dev/cpuset/top-app/uclamp.min" "50"
write "/dev/cpuset/top-app/uclamp.boosted" "1"
write "/dev/cpuset/top-app/uclamp.latency_sensitive" "1"
write "/dev/cpuset/foreground/uclamp.max" "50"
write "/dev/cpuset/foreground/uclamp.min" "20"
write "/dev/cpuset/foreground/uclamp.boosted" "0"
write "/dev/cpuset/foreground/uclamp.latency_sensitive" "0"
write "/dev/cpuset/background/uclamp.max" "50"
write "/dev/cpuset/background/uclamp.min" "10"
write "/dev/cpuset/background/uclamp.boosted" "0"
write "/dev/cpuset/background/uclamp.latency_sensitive" "0"
write "/dev/cpuset/system-background/uclamp.max" "50"
write "/dev/cpuset/system-background/uclamp.min" "10"
write "/dev/cpuset/system-background/uclamp.boosted" "0"
write "/dev/cpuset/system-background/uclamp.latency_sensitive" "0"

# Disable sysctl.conf to prevent system interference
#if [[ -e "/system/etc/sysctl.conf" ]]; then
#  _mv -f "/system/etc/sysctl.conf" "/system/etc/sysctl.conf.bak"
#fi

# Tune pm_freeze_timeout for kernel
write "/sys/power/pm_freeze_timeout" "60000"

# LMK Tweaks
write "$LMK/minfree" "21816,29088,36360,43632,50904,65448"
write "$LMK/oom_reaper" "1"
write "$LMK/batch_kill" "0"
write "$LMK/quick_select" "0"
write "$LMK/time_measure" "0"
write "$LMK/trust_adj_chain" "N"
write "$LMK/cost" "4096"
write "$LMK/watermark_scale_factor" "30"

# Disable Qualcomm per process reclaim for low-range and mid-range devices
write "/sys/module/process_reclaim/parameters/enable_process_reclaim" "0"

# Disable ram-boost relying memplus prefetcher, use traditional swapping
write "/sys/module/memplus_core/parameters/memory_plus_enabled" "0"

# Disable rmnet and gpu logging levels
write "/d/tracing/tracing_on" "0"
write "/sys/module/rmnet_data/parameters/rmnet_data_log_level" "0"
if [[ -e "/sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd" ]]; then
write "/sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd" "0"
write "/sys/kernel/debug/kgsl/kgsl-3d0/log_level_ctxt" "0"
write "/sys/kernel/debug/kgsl/kgsl-3d0/log_level_drv" "0"
write "/sys/kernel/debug/kgsl/kgsl-3d0/ltog_level_mem" "0"
write "/sys/kernel/debug/kgsl/kgsl-3d0/log_level_pwr" "0"
fi

# Disable exception-trace to reduce some overheads
write "/proc/sys/debug/exception-trace" "0"
# Turn off a few additional kernel debuggers
write "/sys/module/bluetooth/parameters/disable_ertm" "Y"
write "/sys/module/bluetooth/parameters/disable_esco" "Y"
write "/sys/module/dwc3/parameters/ep_addr_rxdbg_mask" "0"
write "/sys/module/dwc3/parameters/ep_addr_txdbg_mask" "0"
write "/sys/module/dwc3_msm/parameters/disable_host_mode" "0"
write "/sys/module/hid_apple/parameters/fnmode" "0"
write "/sys/module/hid/parameters/ignore_special_drivers" "0"
write "/sys/module/hid_magicmouse/parameters/emulate_3button" "N"
write "/sys/module/hid_magicmouse/parameters/emulate_scroll_wheel" "N"
write "/sys/module/hid_magicmouse/parameters/scroll_speed" "0"
write "/sys/module/mdss_fb/parameters/backlight_dimmer" "Y"
write "/sys/module/otg_wakelock/parameters/enabled" "N"
write "/sys/module/wakelock/parameters/debug_mask" "0"
write "/sys/module/userwakelock/parameters/debug_mask" "0"
write "/sys/module/binder/parameters/debug_mask" "0"
write "/sys/module/debug/parameters/enable_event_log" "0"
write "/sys/module/glink/parameters/debug_mask" "0"
write "/sys/module/ip6_tunnel/parameters/log_ecn_error" "N"
write "/sys/module/subsystem_restart/parameters/enable_ramdumps" "0"
write "/sys/module/lowmemorykiller/parameters/debug_level" "0"
write "/sys/module/msm_show_resume_irq/parameters/debug_mask" "0"
write "/sys/module/msm_smd_pkt/parameters/debug_mask" "0"
write "/sys/module/sit/parameters/log_ecn_error" "N"
write "/sys/module/smp2p/parameters/debug_mask" "0"
write "/sys/module/usb_bam/parameters/enable_event_log" "0"
write "/sys/module/printk/parameters/console_suspend" "Y"
write "/sys/module/printk/parameters/cpu" "N"
write "/sys/module/printk/parameters/ignore_loglevel" "Y"
write "/sys/module/printk/parameters/pid" "N"
write "/sys/module/printk/parameters/time" "N"
write "/sys/module/service_locator/parameters/enable" "0"
write "/sys/module/subsystem_restart/parameters/disable_restart_work" "1"
for i in $(find /sys/ -name pm_qos_enable); do
write "${i}" "1"
done
for i in $(find /sys/ -name debug_mask); do
write "${i}" "0"
done
for i in $(find /sys/ -name debug_level); do
write "${i}" "0"
done
for i in $(find /sys/ -name edac_mc_log_ce); do
write "${i}" "0"
done
for i in $(find /sys/ -name edac_mc_log_ue); do
write "${i}" "0"
done
for i in $(find /sys/ -name enable_event_log); do
write "${i}" "0"
done
for i in $(find /sys/ -name log_ecn_error); do
write "${i}" "0"
done
for i in $(find /sys/ -name snapshot_crashdumper); do
write "${i}" "0"
done

# Disable UKSM and KSM to save CPU cycles
write "/sys/kernel/mm/uksm/run" "0"
resetprop ro.config.uksm.support false
write "/sys/kernel/mm/ksm/run" "0"
resetprop ro.config.ksm.support false

# EXT4 and F2FS Tweaks
for ext4 in $(_cat /proc/mounts | _grep ext4 | _cut -d ' ' -f2); do
_mount -o remount,noatime,nodiratime,discard,nobarrier,max_batch_time=30000,min_batch_time=15000,commit=40 ${ext4}
done
for ext4 in $(_cat /proc/mounts | _grep ext4 | _cut -d ' ' -f2); do 
_mount -o remount,noatime,delalloc,noauto_da_alloc,nodiratime,nobarrier,discard,max_batch_time=30000,min_batch_time=15000,commit=60 ${ext4}
done
for f2fs in $(_cat /proc/mounts | _grep f2fs | _cut -d ' ' -f2); do 
_mount -o remount,nobarrier ${f2fs}
done
for dsi in /sys/kernel/debug/dsi*
do 
write "${dsi}/dsi-phy-0_allow_phy_power_off" "Y"
write "${dsi}/ulps_enable" "Y"
done
for ext4 in /sys/fs/ext4/*
do
write "${ext4}/inode_readahead_blks" "32"
done
for i in /sys/class/scsi_disk/*
do 
write "${i}/cache_type" "temporary none"
done
for f2fs in /sys/fs/f2fs*/*
do
write "${f2fs}/ram_thresh" "30"
write "${f2fs}/trim_sections" "50"
write "${f2fs}/cp_interval" "250"
done

# Stopping various sevices
for v in 0 1 2 3 4; do
    stop vendor.qti.hardware.perf@$v.$v-service 2>/dev/null
    stop perf-hal-$v-$v 2>/dev/null
done
stop mpdecision 2>/dev/null
stop vendor.perfservice 2>/dev/null
stop traced 2>/dev/null
stop vendor.cnss_diag 2>/dev/null
stop vendor.tcpdump 2>/dev/null
stop logd 2>/dev/null
stop statsd 2>/dev/null
stop traced 2>/dev/null
stop oneplus_brain_service 2>/dev/null
stop perfd 2>/dev/null

# I/O
for queue in /sys/block/*/queue/
do   
# Choose the first scheduler available
    avail_scheds=$(_cat "${queue}scheduler")
	for sched in cfq deadline anxiety noop kyber none
	do
		if [[ "$avail_scheds" == *"$sched"* ]]; then
			write "${queue}scheduler" "$sched"
			break
		fi
	done
	write "${queue}iostats" "0"
	write "${queue}add_random" "0"
    write "${queue}io_poll" "0"
	write "${queue}async_read_expire" "666"
    write "${queue}async_write_expire" "1666"
    write "${queue}fifo_batch" "16"
    write "${queue}sleep_latency_multiple" "5"
    write "${queue}sync_read_expire" "333"
	write "${queue}sync_write_expire" "1166"
	write "${queue}writes_starved" "3"
    write "${queue}iosched/quantum" "4"
    write "${queue}iosched/back_seek_penalty" "1"
    write "${queue}iosched/group_idle" "1"
    write "${queue}iosched/slice_idle" "0"
    write "${queue}iosched/slice_async_rq" "1"
done
for queue in /sys/block/loop*/queue/
do
	write "${queue}rq_affinity" "1"
	write "${queue}rotational" "0"
	write "${queue}nomerges" "1"
	write "${queue}nr_requests" "16"
	write "${queue}read_ahead_kb" "32"
done
for queue in /sys/block/ram*/queue/
do
	write "${queue}rq_affinity" "0"
	write "${queue}rotational" "1"
	write "${queue}nomerges" "0"
	write "${queue}read_ahead_kb" "0"
done
for queue in /sys/block/zram*/queue/
do
	write "${queue}rq_affinity" "0"
	write "${queue}rotational" "0"
	write "${queue}nomerges" "0"
	write "${queue}read_ahead_kb" "0"
done
for queue in /sys/block/dm*/queue/
do
	write "${queue}rq_affinity" "0"
	write "${queue}rotational" "1"
	write "${queue}nomerges" "0"
	write "${queue}nr_requests" "16"
	write "${queue}read_ahead_kb" "32"
done
for queue in /sys/block/mmc*/queue/
do
	write "${queue}rq_affinity" "0"
	write "${queue}rotational" "1"
	write "${queue}nomerges" "0"
	write "${queue}nr_requests" "16"
	write "${queue}read_ahead_kb" "32"
    write "${queue}iosched/fifo_expire_async" "0"
    write "${queue}iosched/fifo_expire_sync" "0"
    write "${queue}iosched/slice_async" "0"
    write "${queue}iosched/slice_sync" "0"
done

# Entropy Tweaks
write "/proc/sys/kernel/random/read_wakeup_threshold" "256"
write "/proc/sys/kernel/random/write_wakeup_threshold" "256"
write "/proc/sys/kernel/random/urandom_min_reseed_secs" "120"

# Drop success flag
exit 0