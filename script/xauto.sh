#!/system/bin/bash
# XTweak X-Auto Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

_cat(){
if [[ -e "/system/bin/cat" ]]; then
/system/bin/cat "$@"
else
/system/xbin/cat "$@"
fi
}

_cut(){
if [[ -e "/system/bin/cut" ]]; then
/system/bin/cut "$@"
else
/system/xbin/cut "$@"
fi
}

_dumpsys(){
if [[ -e "/system/bin/dumpsys" ]]; then
/system/bin/dumpsys "$@"
else
/system/xbin/dumpsys "$@"
fi
}

_awk(){
if [[ -e "/system/bin/awk" ]]; then
/system/bin/awk "$@"
else
/system/xbin/awk "$@"
fi
}

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

_grep(){
if [[ -e "/system/bin/grep" ]]; then
/system/bin/grep "$@"
else
/system/xbin/grep "$@"
fi
}

_bash(){
if [[ -e "/system/bin/bash" ]]; then
/system/bin/bash "$@"
else
/system/xbin/bash "$@"
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

_free(){
if [[ -e "/system/bin/free" ]]; then
/system/bin/free "$@"
else
/system/xbin/free "$@"
fi
}

_sync(){
if [[ -e "/system/bin/sync" ]]; then
/system/bin/sync "$@"
else
/system/xbin/sync "$@"
fi
}

_sleep(){
if [[ -e "/system/bin/sleep" ]]; then
/system/bin/sleep "$@"
else
/system/xbin/sleep "$@"
fi
}

_busybox(){
/data/adb/modules/xtweak/bin/busybox "$@"
}

MODPATH="/data/adb/modules/xtweak"

# Main Variables
toptsdir="/dev/stune/top-app/tasks"
toptcdir="/dev/cpuset/top-app/tasks"
PATH="/storage/emulated/0"
if [[ ! -d "$PATH/XTweak" ]]; then 
_mkdir "$PATH/XTweak"
fi
LOG="$PATH/XTweak/xtweak.log"

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
if [[ "$SCRN_STATE" == "ON" ]]; then 
SCRN_ON=1

else 
SCRN_ON=0
fi
}

while true; do
    # Check screen state
    _screen_state
    if [[ "$(cat /sys/class/leds/lcd-backlight/brightness)" == "0" ]] || [[ "$(cat /sys/class/backlight/panel*-backlight/brightness)" == "0" ]] || [[ "$SCRN_ON" == "0" ]]; then    
    echo "[*] Device has being turned off. Applied Accumulator mode" >> $LOG
    _bash "$MODPATH/script/accumulator.sh"
    _sleep 30
    fi
    # Check battery status
    _battery_status
    if [[ "$BATT_STATUS" == "Charging" ]]; then
    echo "[*] Device is being charged, applied Accumulator mode to reduce battery cycles for better battery backup." >> $LOG
    _bash "$MODPATH/script/accumulator.sh"
    _sleep 60
    fi
    # Check battery %
    _battery_percentage
    if [[ "$BATT_LVL" -eq "25" ]]; then
    echo "[*] Battery has reached 25%, applied Accumulator mode to prolong juicy battery backup." >> $LOG
    _bash "$MODPATH/script/accumulator.sh"
    elif [[ "$BATT_LVL" -eq "5" ]]; then
    echo "[*] Battery is about to die, only 5% remaining." >> $LOG 
    else
    echo "[*] No heavy or noticeable usage found, applied Equalizer mode." >>  $LOG
    _bash "$MODPATH/script/equalizer.sh"
    _sleep 60
    fi
    # Check ram info
    _ram_info
    if [[ "$AVAIL_RAM" -le "$FULL_RAM" ]]; then
    echo "[*] RAM is full, cleared RAM caches." >> $LOG
    _sync
    echo "3" > "/proc/sys/vm/drop_caches"
    fi
    # Check for running games
    for gpid in $(_pgrep -f netease) $(_pgrep -f tipsworks) $(_pgrep -f studiowildcard) $(_pgrep -f wardrumstudios) $(_pgrep -f ExiliumGames) $(_pgrep -f com2us) $(_pgrep -f zuuks) $(_pgrep -f junegaming) $(_pgrep -f pixelbite) $(_pgrep -f junesoftware) $(_pgrep -f sozap) $(_pgrep -f dotemu) $(_pgrep -f playables) $(_pgrep -f playrisedigital) $(_pgrep -f rockstar) $(_pgrep -f blackpanther) $(_pgrep -f noodlecake) $(_pgrep -f linegames) $(_pgrep -f kleientertainment) $(_pgrep -f agaming) $(_pgrep -f generagames) $(_pgrep -f astragon) $(_pgrep -f chucklefish) $(_pgrep -f t2kgames) $(_pgrep -f t2ksports) $(_pgrep -f turner) $(_pgrep -f uplayonline) $(_pgrep -f pubg) $(_pgrep -f dreamotion) $(_pgrep -f snailgames) $(_pgrep -f dexintgames) $(_pgrep -f haegin) $(_pgrep -f panzerdog) $(_pgrep -f igg) $(_pgrep -f gtarcade) $(_pgrep -f naxon) $(_pgrep -f mame4droid) $(_pgrep -f kakaogames) $(_pgrep -f telltalegames) $(_pgrep -f seleuco) $(_pgrep -f innersloth) $(_pgrep -f kiloo) $(_pgrep -f imaginalis) $(_pgrep -f refuelgames) $(_pgrep -f scottgames) $(_pgrep -f clickteam) $(_pgrep -f minigames) $(_pgrep -f headupgames) $(_pgrep -f mobigames) $(_pgrep -f callofduty) $(_pgrep -f ubisoft) $(_pgrep -f ppsspp) $(_pgrep -f cf) $(_pgrep -f feralinteractive) $(_pgrep -f riotgames) $(_pgrep -f playgendary) $(_pgrep -f joymax) $(_pgrep -f deadeffect) $(_pgrep -f blackdesertm) $(_pgrep -f firsttouchgames) $(_pgrep -f standoff2) $(_pgrep -f criticalops) $(_pgrep -f wolvesinteractive) $(_pgrep -f gamedevltd) $(_pgrep -f mojang) $(_pgrep -f miHoYo) $(_pgrep -f miniclip) $(_pgrep -f moontoon) $(_pgrep -f gameloft) $(_pgrep -f netmarble) $(_pgrep -f yoozoogames) $(_pgrep -f eyougame) $(_pgrep -f asphalt) $(_pgrep -f dhlove) $(_pgrep -f fifamobile) $(_pgrep -f freefireth) $(_pgrep -f activision) $(_pgrep -f konami) $(_pgrep -f gamevil) $(_pgrep -f pixonic) $(_pgrep -f gameparadiso) $(_pgrep -f wargaming) $(_pgrep -f madfingergames) $(_pgrep -f supercell) $(_pgrep -f allstar) $(_pgrep -f garena) $(_pgrep -f ea.gp) $(_pgrep -f pixel.gun3d) $(_pgrep -f titan.cd) $(_pgrep -f rpg.fog) $(_pgrep -f edkongames) $(_pgrep -f ohbibi) $(_pgrep -f apex_designs) $(_pgrep -f roblox) $(_pgrep -f halfbrick) $(_pgrep -f maxgames) $(_pgrep -f wildlife.games) $(_pgrep -f blizzard); do
    if [[ "$(_grep -Eo "$gpid" "$toptsdir")" ]] || [[ "$(_grep -Eo "$gpid" "$toptcdir")" ]]; then
    echo "[*] Playing games, changed to Potency mode." >> $LOG
    _bash "$MODPATH/script/potency.sh"
    _sleep 60
    fi
    done
    # Check for social apps
    for spid in $(_pgrep -f whatsapp) $(_pgrep -f musically) $(_pgrep -f adobe) $(_pgrep -f telegram) $(_pgrep -f netflix) $(_pgrep -f wemesh) $(_pgrep -f discord) $(_pgrep -f youtube) $(_pgrep -f facebook) $(_pgrep -f chrome) $(_pgrep -f browser) $(_pgrep -f instagram) $(_pgrep -f docs) $(_pgrep -f twitch); do
    if [[ "$(_grep -Eo "$spid" "$toptsdir")" ]] || [[ "$(_grep -Eo "$spid" "$toptcdir")" ]]; then
    echo "[*] Using social media and streaming apps, applied Equalizer mode." >> $LOG
    _bash "$MODPATH/script/equalizer.sh"
    _sleep 60
    fi
    done
    # Check for benchmarking and heavy apps
    for bpid in $(_pgrep -f geekbench) $(_pgrep -f androbench2) $(_pgrep -f kinemaster) $(_pgrep -f futuremark) $(_pgrep -f cputhrottlingtest) $(_pgrep -f camera) $(_pgrep -f cam) $(_pgrep -f antutu); do
    if [[ "$(_grep -Eo "$bpid" "$toptsdir")" ]] || [[ "$(_grep -Eo "$bpid" "$toptcdir")" ]]; then  
    echo "[*] Using benchmarking and heavy apps, applied Output mode." >> $LOG
    _bash "$MODPATH/script/output.sh"
    _sleep 60
    fi
    done
done
