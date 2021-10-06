#!/system/bin/sh
# XTweak - Main & Misc. Optimizations Library
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

#############################
# Main Optimizations Functions
#############################

accumulator(){
# Kernel Tweaks
write "$KERNEL/perf_cpu_time_max_percent" "2"
write "$KERNEL/sched_autogroup_enabled" "1"
write "$KERNEL/sched_cfs_boost" "0"
write "$KERNEL/sched_child_runs_first" "0"
write "$KERNEL/sched_cstat_aware" "1"
write "$KERNEL/sched_tunable_scaling" "0"
write "$KERNEL/sched_latency_ns" "5000000"
write "$KERNEL/sched_migration_cost_ns" "500000"
write "$KERNEL/sched_min_granularity_ns" "1000000"
write "$KERNEL/sched_nr_migrate" "256"
write "$KERNEL/sched_rr_timeslice_ns" "100"
write "$KERNEL/sched_rt_period_us" "1000000"
write "$KERNEL/sched_rt_runtime_us" "950000"
write "$KERNEL/sched_shares_window_ns" "10000000"
write "$KERNEL/sched_sync_hint_enable" "1"
write "$KERNEL/sched_time_avg_ms" "1000"
write "$KERNEL/sched_tunable_scaling" "0"
write "$KERNEL/sched_use_walt_cpu_util" "1"
write "$KERNEL/sched_use_walt_task_util" "1"
write "$KERNEL/sched_wakeup_granularity_ns" "2500000"
write "$KERNEL/sched_walt_cpu_high_irqload" "20000000"
write "$KERNEL/sched_walt_init_task_load_pct" "10"
write "$KERNEL/hung_task_timeout_secs" "0"

# VM (Virtual Machine) Tweaks
write "$VM/dirty_background_ratio" "3"
write "$VM/dirty_ratio" "6"
write "$VM/dirty_expire_centisecs" "1000"
write "$VM/dirty_writeback_centisecs" "1000"
write "$VM/page-cluster" "0"
write "$VM/reap_mem_on_sigkill" "1"
write "$VM/stat_interval" "5"
write "$VM/swappiness" "100"
write "$VM/overcommit_ratio" "30"
write "$VM/vfs_cache_pressure" "100"
write "$VM/extfrag_threshold" "750"
write "$VM/swap_ratio" "40"
write "$VM/drop_caches" "3"
write "$VM/breath_period" "0"
write "$VM/breath_priority" "-1001"
write "$VM/memory_plus" "0"

# CPU Tweaks
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/
do
    avail_govs="$($cat "${cpu}scaling_available_governors")"
    if [ "$avail_govs" = *"schedutil"* ]
    then
        write "${cpu}scaling_governor" "schedutil"
        write "${cpu}schedutil/up_rate_limit_us" "5000"
        write "${cpu}schedutil/down_rate_limit_us" "5000"
        write "${cpu}schedutil/rate_limit_us" "5000"
        write "${cpu}schedutil/hispeed_load" "99"
        write "${cpu}schedutil/hispeed_freq" "$($cat "${cpu}cpuinfo_max_freq")"
    elif [ "$avail_govs" = *"interactive"* ]
    then
        write "${cpu}scaling_governor" "interactive"
        write "${cpu}interactive/timer_rate" "5000"
        write "${cpu}interactive/min_sample_time" "5000"
        write "${cpu}interactive/go_hispeed_load" "99"
        write "${cpu}interactive/hispeed_freq" "$($cat "${cpu}cpuinfo_max_freq")"
    fi
done

# GPU Tweaks
write "/sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate" "1"
write "/sys/class/kgsl/kgsl-3d0/devfreq/polling_interval" "10"
write "/sys/class/kgsl/kgsl-3d0/idle_timer" "62"
write "/sys/class/kgsl/kgsl-3d0/force_clk_on" "0"
write "/sys/class/kgsl/kgsl-3d0/max_pwrlevel" "0"
write "/sys/class/kgsl/kgsl-3d0/default_pwrlevel" "5"
write "/sys/class/kgsl/kgsl-3d0/thermal_pwrlevel" "3"
write "/sys/class/kgsl/kgsl-3d0/force_bus_on" "0"
write "/sys/class/kgsl/kgsl-3d0/force_no_nap" "0"
write "/sys/class/kgsl/kgsl-3d0/force_rail_on" "0"
write "/sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost" "0"
write "/sys/devices/soc/kgsl-3d0/devfreq/kgsl-3d0/adrenoboost" "0"
write "/sys/class/kgsl/kgsl-3d0/bus_split" "1"
write "/sys/class/kgsl/kgsl-3d0/throttling" "1"

# Disable Adreno Idler for Accumulator
write "/sys/module/adreno_idler/parameters/adreno_idler_active" "N"

# Tune sched_domain values for better latency and perf
for sched_domain in /proc/sys/kernel/sched_domain/cpu*/domain*/
do
write "${sched_domain}min_interval" "4"
write "${sched_domain}max_interval" "2"
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

# Blkio Tweaks
write "/dev/blkio/blkio.weight" "1000"
write "/dev/blkio/blkio.leaf_weight" "1000"
write "/dev/blkio/background/blkio.weight" "100"
write "/dev/blkio/background/blkio.leaf_weight" "100"

# Enable UFS powersaving
for ufs in /sys/devices/soc/*/
do
write "${ufs}clkscale_enable" "1"
write "${ufs}clkgate_enable" "1"
write "${ufs}hibern8_on_idle_enable" "1"
done
write "/sys/class/typec/port0/port_type" "sink"
write "/sys/module/lpm_levels/parameters/sleep_disabled" "N"

# Multi-core powersaving
if [ -e "/sys/devices/system/cpu/sched_mc_power_savings" ]; then
write "/sys/devices/system/cpu/sched_mc_power_savings" "2"
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
if [ -e "/system/etc/sysctl.conf" ]; then
  $mv -f "/system/etc/sysctl.conf" "/system/etc/sysctl.conf.bak"
fi

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
if [ -e "/sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd" ]; then
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
for i in $($find /sys/ -name pm_qos_enable); do
write "${i}" "1"
done
for i in $($find /sys/ -name debug_mask); do
write "${i}" "0"
done
for i in $($find /sys/ -name debug_level); do
write "${i}" "0"
done
for i in $($find /sys/ -name edac_mc_log_ce); do
write "${i}" "0"
done
for i in $($find /sys/ -name edac_mc_log_ue); do
write "${i}" "0"
done
for i in $($find /sys/ -name enable_event_log); do
write "${i}" "0"
done
for i in $($find /sys/ -name log_ecn_error); do
write "${i}" "0"
done
for i in $($find /sys/ -name snapshot_crashdumper); do
write "${i}" "0"
done

# Disable UKSM and KSM to save CPU cycles
write "/sys/kernel/mm/uksm/run" "0"
$resetprop ro.config.uksm.support false
write "/sys/kernel/mm/ksm/run" "0"
$resetprop ro.config.ksm.support false

# EXT4 and F2FS Tweaks
#for ext4 in $($cat /proc/mounts | $grep ext4 | $cut -d ' ' -f2); do
#$mount -o remount,noatime,nodiratime,discard,nobarrier,max_batch_time=30000,min_batch_time=15000,commit=40 ${ext4}
#done
#for ext4 in $($cat /proc/mounts | $grep ext4 | $cut -d ' ' -f2); do 
#$mount -o remount,noatime,delalloc,noauto_da_alloc,nodiratime,nobarrier,discard,max_batch_time=30000,min_batch_time=15000,commit=60 ${ext4}
#done
#for f2fs in $($cat /proc/mounts | $grep f2fs | $cut -d ' ' -f2); do 
#$mount -o remount,nobarrier ${f2fs}
#done
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
    stop vendor.qti.hardware.perf@${v}.${v}-service 2>/dev/null
    stop perf-hal-${v}-${v} 2>/dev/null
done
stop vendor.perfservice 2>/dev/null
stop traced 2>/dev/null
stop vendor.cnss_diag 2>/dev/null
stop vendor.tcpdump 2>/dev/null
stop logd 2>/dev/null
stop statsd 2>/dev/null
stop traced 2>/dev/null
stop oneplus_brain_service 2>/dev/null
stop perfd 2>/dev/null

# Better to keep mpdecision alive if you are running out of battery
start mpdecision 2>/dev/null

# I/O Tweaks
for queue in /sys/block/*/queue/
do   
# Choose the first scheduler available
    avail_scheds=$($cat "${queue}scheduler")
	for sched in cfq deadline anxiety noop kyber none
	do
		if [ "$avail_scheds" = *"$sched"* ]; then
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
	write "${queue}nr_requests" "512"
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
	write "${queue}nr_requests" "512"
	write "${queue}read_ahead_kb" "32"
done
for queue in /sys/block/mmc*/queue/
do
	write "${queue}rq_affinity" "0"
	write "${queue}rotational" "1"
	write "${queue}nomerges" "0"
	write "${queue}nr_requests" "512"
	write "${queue}read_ahead_kb" "32"
    write "${queue}iosched/fifo_expire_async" "0"
    write "${queue}iosched/fifo_expire_sync" "0"
    write "${queue}iosched/slice_async" "0"
    write "${queue}iosched/slice_sync" "0"
done

# Entropy Tweaks
write "/proc/sys/kernel/random/read_wakeup_threshold" "128"
write "/proc/sys/kernel/random/write_wakeup_threshold" "128"
write "/proc/sys/kernel/random/urandom_min_reseed_secs" "120"
}

equalizer(){
# Kernel Tweaks
write "$KERNEL/perf_cpu_time_max_percent" "5"
write "$KERNEL/sched_autogroup_enabled" "1"
write "$KERNEL/sched_cfs_boost" "0"
write "$KERNEL/sched_child_runs_first" "1"
write "$KERNEL/sched_cstat_aware" "1"
write "$KERNEL/sched_tunable_scaling" "0"
write "$KERNEL/sched_latency_ns" "4000000"
write "$KERNEL/sched_migration_cost_ns" "5000000"
write "$KERNEL/sched_min_granularity_ns" "500000"
write "$KERNEL/sched_nr_migrate" "32"
write "$KERNEL/sched_rr_timeslice_ns" "100"
write "$KERNEL/sched_rt_period_us" "1000000"
write "$KERNEL/sched_rt_runtime_us" "950000"
write "$KERNEL/sched_shares_window_ns" "10000000"
write "$KERNEL/sched_sync_hint_enable" "1"
write "$KERNEL/sched_time_avg_ms" "1000"
write "$KERNEL/sched_tunable_scaling" "0"
write "$KERNEL/sched_use_walt_cpu_util" "1"
write "$KERNEL/sched_use_walt_task_util" "1"
write "$KERNEL/sched_wakeup_granularity_ns" "2000000"
write "$KERNEL/sched_walt_cpu_high_irqload" "20000000"
write "$KERNEL/sched_walt_init_task_load_pct" "20"
write "$KERNEL/hung_task_timeout_secs" "0"
# VM (Virtual Machine) Tweaks
write "$VM/dirty_background_ratio" "10"
write "$VM/dirty_ratio" "30"
write "$VM/dirty_expire_centisecs" "3000"
write "$VM/dirty_writeback_centisecs" "3000"
write "$VM/page-cluster" "0"
write "$VM/reap_mem_on_sigkill" "1"
write "$VM/stat_interval" "5"
write "$VM/swappiness" "100"
write "$VM/overcommit_ratio" "30"
write "$VM/vfs_cache_pressure" "100"
write "$VM/extfrag_threshold" "750"
write "$VM/swap_ratio" "40"
write "$VM/drop_caches" "3"
write "$VM/breath_period" "0"
write "$VM/breath_priority" "-1001"
write "$VM/memory_plus" "0"

# CPU Tweaks
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/
do
    avail_govs="$($cat "${cpu}scaling_available_governors")"
    if [ "$avail_govs" = *"schedutil"* ]
    then
        write "${cpu}scaling_governor" "schedutil"
        write "${cpu}schedutil/up_rate_limit_us" "4000"
        write "${cpu}schedutil/down_rate_limit_us" "16000"
        write "${cpu}schedutil/rate_limit_us" "4000"
        write "${cpu}schedutil/hispeed_load" "90"
        write "${cpu}schedutil/hispeed_freq" "$($cat "${cpu}cpuinfo_max_freq")"
    elif [ "$avail_govs" = *"interactive"* ]
    then
        write "${cpu}scaling_governor" "interactive"
        write "${cpu}interactive/timer_rate" "4000"
        write "${cpu}interactive/min_sample_time" "4000"
        write "${cpu}interactive/go_hispeed_load" "90"	
        write "${cpu}interactive/hispeed_freq" "$($cat "${cpu}cpuinfo_max_freq")"
    fi
done

# GPU Tweaks
write "/sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate" "1"
write "/sys/class/kgsl/kgsl-3d0/devfreq/polling_interval" "10"
write "/sys/class/kgsl/kgsl-3d0/idle_timer" "62"
write "/sys/class/kgsl/kgsl-3d0/force_clk_on" "0"
write "/sys/class/kgsl/kgsl-3d0/max_pwrlevel" "0"
write "/sys/class/kgsl/kgsl-3d0/default_pwrlevel" "4"
write "/sys/class/kgsl/kgsl-3d0/thermal_pwrlevel" "2"
write "/sys/class/kgsl/kgsl-3d0/force_bus_on" "0"
write "/sys/class/kgsl/kgsl-3d0/force_no_nap" "0"
write "/sys/class/kgsl/kgsl-3d0/force_rail_on" "0"
write "/sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost" "1"
write "/sys/devices/soc/kgsl-3d0/devfreq/kgsl-3d0/adrenoboost" "1"
write "/sys/class/kgsl/kgsl-3d0/bus_split" "1"
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
write "${ufs}clkscale_enable" "1"
write "${ufs}clkgate_enable" "1"
write "${ufs}hibern8_on_idle_enable" "1"
done
write "/sys/class/typec/port0/port_type" "sink"
write "/sys/module/lpm_levels/parameters/sleep_disabled" "N"

# Multi-core powersaving
if [ -e "/sys/devices/system/cpu/sched_mc_power_savings" ]; then
write "/sys/devices/system/cpu/sched_mc_power_savings" "1"
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
if [ -e "/system/etc/sysctl.conf" ]; then
  $mv -f "/system/etc/sysctl.conf" "/system/etc/sysctl.conf.bak"
fi

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
if [ -e "/sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd" ]; then
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
for i in $($find /sys/ -name pm_qos_enable); do
write "${i}" "1"
done
for i in $($find /sys/ -name debug_mask); do
write "${i}" "0"
done
for i in $($find /sys/ -name debug_level); do
write "${i}" "0"
done
for i in $($find /sys/ -name edac_mc_log_ce); do
write "${i}" "0"
done
for i in $($find /sys/ -name edac_mc_log_ue); do
write "${i}" "0"
done
for i in $($find /sys/ -name enable_event_log); do
write "${i}" "0"
done
for i in $($find /sys/ -name log_ecn_error); do
write "${i}" "0"
done
for i in $($find /sys/ -name snapshot_crashdumper); do
write "${i}" "0"
done

# Disable UKSM and KSM to save CPU cycles
write "/sys/kernel/mm/uksm/run" "0"
$resetprop ro.config.uksm.support false
write "/sys/kernel/mm/ksm/run" "0"
$resetprop ro.config.ksm.support false

# EXT4 and F2FS Tweaks
#for ext4 in $($cat /proc/mounts | $grep ext4 | $cut -d ' ' -f2); do
#$mount -o remount,noatime,nodiratime,discard,nobarrier,max_batch_time=30000,min_batch_time=15000,commit=40 ${ext4}
#done
#for ext4 in $($cat /proc/mounts | $grep ext4 | $cut -d ' ' -f2); do 
#$mount -o remount,noatime,delalloc,noauto_da_alloc,nodiratime,nobarrier,discard,max_batch_time=30000,min_batch_time=15000,commit=60 ${ext4}
#done
#for f2fs in $($cat /proc/mounts | $grep f2fs | $cut -d ' ' -f2); do 
#$mount -o remount,nobarrier ${f2fs}
#done
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
    stop vendor.qti.hardware.perf@${v}.${v}-service 2>/dev/null
    stop perf-hal-${v}-${v} 2>/dev/null
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
    avail_scheds=$($cat "${queue}scheduler")
	for sched in cfq deadline anxiety noop kyber none
	do
		if [ "$avail_scheds" = *"$sched"* ]; then
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
	write "${queue}nr_requests" "32"
	write "${queue}read_ahead_kb" "64"
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
	write "${queue}nr_requests" "32"
	write "${queue}read_ahead_kb" "64"
done
for queue in /sys/block/mmc*/queue/
do
	write "${queue}rq_affinity" "0"
	write "${queue}rotational" "1"
	write "${queue}nomerges" "0"
	write "${queue}nr_requests" "32"
	write "${queue}read_ahead_kb" "64"
    write "${queue}iosched/fifo_expire_async" "0"
    write "${queue}iosched/fifo_expire_sync" "0"
    write "${queue}iosched/slice_async" "0"
    write "${queue}iosched/slice_sync" "0"
done

# Entropy Tweaks
write "/proc/sys/kernel/random/read_wakeup_threshold" "128"
write "/proc/sys/kernel/random/write_wakeup_threshold" "256"
write "/proc/sys/kernel/random/urandom_min_reseed_secs" "120"
}

potency(){
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
    avail_govs="$($cat "${cpu}scaling_available_governors")"
    if [ "$avail_govs" = *"schedutil"* ]
    then
        write "${cpu}scaling_governor" "schedutil"
        write "${cpu}schedutil/up_rate_limit_us" "0"
        write "${cpu}schedutil/down_rate_limit_us" "0"
        write "${cpu}schedutil/rate_limit_us" "0"
        write "${cpu}schedutil/hispeed_load" "85"
        write "${cpu}schedutil/hispeed_freq" "$($cat "${cpu}cpuinfo_max_freq")"
    elif [ "$avail_govs" = *"interactive"* ]
    then
        write "${cpu}scaling_governor" "interactive"
        write "${cpu}interactive/timer_rate" "0"
        write "${cpu}interactive/min_sample_time" "0"
        write "${cpu}interactive/go_hispeed_load" "85"
        write "${cpu}interactive/hispeed_freq" "$($cat "${cpu}cpuinfo_max_freq")"
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
if [ -e "/sys/devices/system/cpu/sched_mc_power_savings" ]; then
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
if [ -e "/system/etc/sysctl.conf" ]; then
  $mv -f "/system/etc/sysctl.conf" "/system/etc/sysctl.conf.bak"
fi

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
if [ -e "/sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd" ]; then
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
for i in $($find /sys/ -name pm_qos_enable); do
write "${i}" "1"
done
for i in $($find /sys/ -name debug_mask); do
write "${i}" "0"
done
for i in $($find /sys/ -name debug_level); do
write "${i}" "0"
done
for i in $($find /sys/ -name edac_mc_log_ce); do
write "${i}" "0"
done
for i in $($find /sys/ -name edac_mc_log_ue); do
write "${i}" "0"
done
for i in $($find /sys/ -name enable_event_log); do
write "${i}" "0"
done
for i in $($find /sys/ -name log_ecn_error); do
write "${i}" "0"
done
for i in $($find /sys/ -name snapshot_crashdumper); do
write "${i}" "0"
done

# Disable UKSM and KSM to save CPU cycles
write "/sys/kernel/mm/uksm/run" "0"
resetprop ro.config.uksm.support false
write "/sys/kernel/mm/ksm/run" "0"
resetprop ro.config.ksm.support false

# EXT4 and F2FS Tweaks
#for ext4 in $($cat /proc/mounts | $grep ext4 | $cut -d ' ' -f2); do
#$mount -o remount,noatime,nodiratime,discard,nobarrier,max_batch_time=30000,min_batch_time=15000,commit=40 ${ext4}
#done
#for ext4 in $($cat /proc/mounts | $grep ext4 | $cut -d ' ' -f2); do 
#$mount -o remount,noatime,delalloc,noauto_da_alloc,nodiratime,nobarrier,discard,max_batch_time=30000,min_batch_time=15000,commit=60 ${ext4}
#done
#for f2fs in $($cat /proc/mounts | $grep f2fs | $cut -d ' ' -f2); do 
#$mount -o remount,nobarrier ${f2fs}
#done
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
    stop perf-hal-${v}-${v} 2>/dev/null
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
    avail_scheds=$($cat "${queue}scheduler")
	for sched in cfq deadline anxiety noop kyber none
	do
		if [ "$avail_scheds" = *"$sched"* ]; then
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
}

output(){
# Kernel Tweaks
write "$KERNEL/perf_cpu_time_max_percent" "20"
write "$KERNEL/sched_autogroup_enabled" "0"
write "$KERNEL/sched_cfs_boost" "1"
write "$KERNEL/sched_child_runs_first" "0"
write "$KERNEL/sched_cstat_aware" "1"
write "$KERNEL/sched_tunable_scaling" "0"
write "$KERNEL/sched_latency_ns" "10000000"
write "$KERNEL/sched_migration_cost_ns" "5000000"
write "$KERNEL/sched_min_granularity_ns" "1666666"
write "$KERNEL/sched_nr_migrate" "128"
write "$KERNEL/sched_rr_timeslice_ns" "100"
write "$KERNEL/sched_rt_period_us" "1000000"
write "$KERNEL/sched_rt_runtime_us" "950000"
write "$KERNEL/sched_shares_window_ns" "10000000"
write "$KERNEL/sched_sync_hint_enable" "1"
write "$KERNEL/sched_time_avg_ms" "1000"
write "$KERNEL/sched_tunable_scaling" "0"
write "$KERNEL/sched_use_walt_cpu_util" "1"
write "$KERNEL/sched_use_walt_task_util" "1"
write "$KERNEL/sched_wakeup_granularity_ns" "5000000"
write "$KERNEL/sched_walt_cpu_high_irqload" "20000000"
write "$KERNEL/sched_walt_init_task_load_pct" "20"
write "$KERNEL/hung_task_timeout_secs" "0"

# VM (Virtual Machine) Tweaks
write "$VM/dirty_background_ratio" "15"
write "$VM/dirty_ratio" "30"
write "$VM/dirty_expire_centisecs" "3000"
write "$VM/dirty_writeback_centisecs" "3000"
write "$VM/page-cluster" "0"
write "$VM/reap_mem_on_sigkill" "1"
write "$VM/stat_interval" "5"
write "$VM/swappiness" "100"
write "$VM/overcommit_ratio" "30"
write "$VM/vfs_cache_pressure" "80"
write "$VM/extfrag_threshold" "750"
write "$VM/swap_ratio" "40"
write "$VM/drop_caches" "3"
write "$VM/breath_period" "0"
write "$VM/breath_priority" "-1001"
write "$VM/memory_plus" "0"

# CPU Tweaks
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/
do
    avail_govs="$($cat "${cpu}scaling_available_governors")"
    if [ "$avail_govs" = *"schedutil"* ]
    then
        write "${cpu}scaling_governor" "schedutil"
        write "${cpu}schedutil/up_rate_limit_us" "10000"
        write "${cpu}schedutil/down_rate_limit_us" "40000"
        write "${cpu}schedutil/rate_limit_us" "10000"
        write "${cpu}schedutil/hispeed_load" "85"
        write "${cpu}schedutil/hispeed_freq" "$($cat "${cpu}cpuinfo_max_freq")"
    elif [ "$avail_govs" = *"interactive"* ]
    then
        write "${cpu}scaling_governor" "interactive"
        write "${cpu}interactive/timer_rate" "10000"
        write "${cpu}interactive/min_sample_time" "10000"
        write "${cpu}interactive/go_hispeed_load" "85"
        write "${cpu}interactive/hispeed_freq" "$($cat "${cpu}cpuinfo_max_freq")"
    fi
done

# GPU Tweaks
write "/sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate" "1"
write "/sys/class/kgsl/kgsl-3d0/devfreq/polling_interval" "10"
write "/sys/class/kgsl/kgsl-3d0/idle_timer" "100000"
write "/sys/class/kgsl/kgsl-3d0/force_clk_on" "1"
write "/sys/class/kgsl/kgsl-3d0/max_pwrlevel" "0"
write "/sys/class/kgsl/kgsl-3d0/default_pwrlevel" "1"
write "/sys/class/kgsl/kgsl-3d0/thermal_pwrlevel" "1"
write "/sys/class/kgsl/kgsl-3d0/force_bus_on" "1"
write "/sys/class/kgsl/kgsl-3d0/force_no_nap" "1"
write "/sys/class/kgsl/kgsl-3d0/force_rail_on" "1"
write "/sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost" "2"
write "/sys/devices/soc/kgsl-3d0/devfreq/kgsl-3d0/adrenoboost" "2"
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
if [ -e "/sys/devices/system/cpu/sched_mc_power_savings" ]; then
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
if [ -e "/system/etc/sysctl.conf" ]; then
  $mv -f "/system/etc/sysctl.conf" "/system/etc/sysctl.conf.bak"
fi

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
if [ -e "/sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd" ]; then
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
for i in $($find /sys/ -name pm_qos_enable); do
write "${i}" "1"
done
for i in $($find /sys/ -name debug_mask); do
write "${i}" "0"
done
for i in $($find /sys/ -name debug_level); do
write "${i}" "0"
done
for i in $($find /sys/ -name edac_mc_log_ce); do
write "${i}" "0"
done
for i in $($find /sys/ -name edac_mc_log_ue); do
write "${i}" "0"
done
for i in $($find /sys/ -name enable_event_log); do
write "${i}" "0"
done
for i in $($find /sys/ -name log_ecn_error); do
write "${i}" "0"
done
for i in $($find /sys/ -name snapshot_crashdumper); do
write "${i}" "0"
done

# Disable UKSM and KSM to save CPU cycles
write "/sys/kernel/mm/uksm/run" "0"
$resetprop ro.config.uksm.support false
write "/sys/kernel/mm/ksm/run" "0"
$resetprop ro.config.ksm.support false

# EXT4 and F2FS Tweaks
#for ext4 in $($cat /proc/mounts | $grep ext4 | $cut -d ' ' -f2); do
#$mount -o remount,noatime,nodiratime,discard,nobarrier,max_batch_time=30000,min_batch_time=15000,commit=40 ${ext4}
#done
#for ext4 in $($cat /proc/mounts | $grep ext4 | $cut -d ' ' -f2); do 
#$mount -o remount,noatime,delalloc,noauto_da_alloc,nodiratime,nobarrier,discard,max_batch_time=30000,min_batch_time=15000,commit=60 ${ext4}
#done
#for f2fs in $($cat /proc/mounts | $grep f2fs | $cut -d ' ' -f2); do 
#$mount -o remount,nobarrier ${f2fs}
#done
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
    stop vendor.qti.hardware.perf@${v}.${v}-service 2>/dev/null
    stop perf-hal-${v}-${v} 2>/dev/null
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

# I/O Tweaks
for queue in /sys/block/*/queue/
do   
# Choose the first scheduler available
    avail_scheds=$($cat "${queue}scheduler")
	for sched in cfq deadline anxiety noop kyber none
	do
		if [ "$avail_scheds" = *"$sched"* ]; then
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
	write "${queue}nr_requests" "512"
	write "${queue}read_ahead_kb" "128"
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
	write "${queue}nr_requests" "512"
	write "${queue}read_ahead_kb" "128"
done
for queue in /sys/block/mmc*/queue/
do
	write "${queue}rq_affinity" "0"
	write "${queue}rotational" "1"
	write "${queue}nomerges" "0"
	write "${queue}nr_requests" "512"
	write "${queue}read_ahead_kb" "128"
    write "${queue}iosched/fifo_expire_async" "0"
    write "${queue}iosched/fifo_expire_sync" "0"
    write "${queue}iosched/slice_async" "0"
    write "${queue}iosched/slice_sync" "0"
done

# Entropy Tweaks
write "/proc/sys/kernel/random/read_wakeup_threshold" "256"
write "/proc/sys/kernel/random/write_wakeup_threshold" "384"
write "/proc/sys/kernel/random/urandom_min_reseed_secs" "120"
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