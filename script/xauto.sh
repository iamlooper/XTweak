#!/system/bin/sh
# XTweak™ | XAuto Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

modpath="/data/adb/modules/xtweak/"

# Load lib
. "${modpath}script/xtweak.sh"

# Main Variables
toptsdir="/dev/stune/top-app/tasks"
toptcdir="/dev/cpuset/top-app/tasks"
xt="/storage/emulated/0/XTweak"
if [ ! -d "${xt}" ]; then 
mkdir "${xt}"
fi
log="${xt}/xtweak.log"

while true
do
    # Check if main wants to keep service alive
    if [ "$(cat "/data/xauto.txt")" = "off" ]; then
       break
    fi
    # Check screen state
    screen_state
    if [ "$(cat /sys/class/leds/lcd-backlight/brightness)" = "0" ] || [ "$(cat /sys/class/backlight/panel*-backlight/brightness)" = "0" ] || [ "$scrn_on" = "0" ]; then    
    echo "[*] Device has being turned off. Applied Accumulator mode" >> $log
    echo "" >> $log
    accumulator
    sleep 30
    fi
    # Check battery status
    battery_status
    if [ "$batt_status" = "Charging" ]; then
    echo "[*] Device is being charged, applied Accumulator mode to reduce battery cycles for better battery backup." >> $log
    echo "" >> $log
    accumulator
    sleep 60
    fi
    # Check battery %
    battery_percentage
    if [ "$batt_lvl" -eq "25" ]; then
    echo "[*] Battery has reached 25%, applied Accumulator mode to prolong juicy battery backup." >> $log
    echo "" >> $log
    accumulator
    elif [ "$batt_lvl" -eq "5" ]; then
    echo "[*] Battery is about to die, only 5% remaining." >> $log 
    echo "" >> $log
    else
    echo "[*] No heavy or noticeable usage found, applied Equalizer mode." >>  $log
    echo "" >> $log
    equalizer
    sleep 60
    fi
    # Check ram info
    ram_info
    if [ "$avail_ram" -le "$full_ram" ]; then
    echo "[*] RAM is full, cleared RAM caches." >> $log
    echo "" >> $log
    sync
    echo "3" > "/proc/sys/vm/drop_caches"
    fi
    # Check for running games
    for gpid in $(pgrep -f netease) $(pgrep -f tipsworks) $(pgrep -f studiowildcard) $(pgrep -f wardrumstudios) $(pgrep -f ExiliumGames) $(pgrep -f com2us) $(pgrep -f zuuks) $(pgrep -f junegaming) $(pgrep -f pixelbite) $(pgrep -f junesoftware) $(pgrep -f sozap) $(pgrep -f dotemu) $(pgrep -f playables) $(pgrep -f playrisedigital) $(pgrep -f rockstar) $(pgrep -f blackpanther) $(pgrep -f noodlecake) $(pgrep -f linegames) $(pgrep -f kleientertainment) $(pgrep -f agaming) $(pgrep -f generagames) $(pgrep -f astragon) $(pgrep -f chucklefish) $(pgrep -f t2kgames) $(pgrep -f t2ksports) $(pgrep -f turner) $(pgrep -f uplayonline) $(pgrep -f pubg) $(pgrep -f dreamotion) $(pgrep -f snailgames) $(pgrep -f dexintgames) $(pgrep -f haegin) $(pgrep -f panzerdog) $(pgrep -f igg) $(pgrep -f gtarcade) $(pgrep -f naxon) $(pgrep -f mame4droid) $(pgrep -f kakaogames) $(pgrep -f telltalegames) $(pgrep -f seleuco) $(pgrep -f innersloth) $(pgrep -f kiloo) $(pgrep -f imaginalis) $(pgrep -f refuelgames) $(pgrep -f scottgames) $(pgrep -f clickteam) $(pgrep -f minigames) $(pgrep -f headupgames) $(pgrep -f mobigames) $(pgrep -f callofduty) $(pgrep -f ubisoft) $(pgrep -f ppsspp) $(pgrep -f cf) $(pgrep -f feralinteractive) $(pgrep -f riotgames) $(pgrep -f playgendary) $(pgrep -f joymax) $(pgrep -f deadeffect) $(pgrep -f blackdesertm) $(pgrep -f firsttouchgames) $(pgrep -f standoff2) $(pgrep -f criticalops) $(pgrep -f wolvesinteractive) $(pgrep -f gamedevltd) $(pgrep -f mojang) $(pgrep -f miHoYo) $(pgrep -f miniclip) $(pgrep -f moontoon) $(pgrep -f gameloft) $(pgrep -f netmarble) $(pgrep -f yoozoogames) $(pgrep -f eyougame) $(pgrep -f asphalt) $(pgrep -f dhlove) $(pgrep -f fifamobile) $(pgrep -f freefireth) $(pgrep -f activision) $(pgrep -f konami) $(pgrep -f gamevil) $(pgrep -f pixonic) $(pgrep -f gameparadiso) $(pgrep -f wargaming) $(pgrep -f madfingergames) $(pgrep -f supercell) $(pgrep -f allstar) $(pgrep -f garena) $(pgrep -f ea.gp) $(pgrep -f pixel.gun3d) $(pgrep -f titan.cd) $(pgrep -f rpg.fog) $(pgrep -f edkongames) $(pgrep -f ohbibi) $(pgrep -f apex_designs) $(pgrep -f roblox) $(pgrep -f halfbrick) $(pgrep -f maxgames) $(pgrep -f wildlife.games) $(pgrep -f blizzard); do
    if [ "$(grep -Eo "$gpid" "$toptsdir")" ] || [ "$(grep -Eo "$gpid" "$toptcdir")" ]; then
    echo "[*] Playing games, changed to Potency mode." >> $log
    echo "" >> $log
    potency
    sleep 60
    fi
    done
    # Check for social apps
    for spid in $(pgrep -f whatsapp) $(pgrep -f musically) $(pgrep -f adobe) $(pgrep -f telegram) $(pgrep -f netflix) $(pgrep -f wemesh) $(pgrep -f discord) $(pgrep -f youtube) $(pgrep -f facebook) $(pgrep -f chrome) $(pgrep -f browser) $(pgrep -f instagram) $(pgrep -f docs) $(pgrep -f twitch); do
    if [ "$(grep -Eo "$spid" "$toptsdir")" ] || [ "$(grep -Eo "$spid" "$toptcdir")" ]; then
    echo "[*] Using social media and streaming apps, applied Equalizer mode." >> $log
    echo "" >> $log
    equalizer
    sleep 60
    fi
    done
    # Check for benchmarking and heavy apps
    for bpid in $(pgrep -f geekbench) $(pgrep -f androbench2) $(pgrep -f kinemaster) $(pgrep -f futuremark) $(pgrep -f cputhrottlingtest) $(pgrep -f camera) $(pgrep -f cam) $(pgrep -f antutu); do
    if [ "$(grep -Eo "$bpid" "$toptsdir")" ] || [ "$(grep -Eo "$bpid" "$toptcdir")" ]; then  
    echo "[*] Using benchmarking and heavy apps, applied Output mode." >> $log
    echo "" >> $log
    output
    sleep 60
    fi
    done
done
