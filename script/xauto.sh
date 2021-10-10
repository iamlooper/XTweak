#!/system/bin/sh
# XTweak™ | XAuto Script
# Author: LOOPER (iamlooper @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github)
# Don't take any work from here until you maintain proper credits of respective devs.

MODPATH="/data/adb/modules/xtweak/"

# Load lib
. "${MODPATH}script/xtweak.sh"

# Main Variables
toptsdir="/dev/stune/top-app/tasks"
toptcdir="/dev/cpuset/top-app/tasks"
XT="/storage/emulated/0/XTweak"
if [ ! -d "$XT" ]; then 
$bb mkdir "$XT"
fi
LOG="$XT/xtweak.log"

while true
do
    # Check if main wants to keep service alive
    if [ "$($bb cat "/data/xauto.txt")" = "off" ]; then
       break
    fi
    # Check screen state
    screen_state
    if [ "$($bb cat /sys/class/leds/lcd-backlight/brightness)" = "0" ] || [ "$($bb cat /sys/class/backlight/panel*-backlight/brightness)" = "0" ] || [ "$SCRN_ON" = "0" ]; then    
    echo "[*] Device has being turned off. Applied Accumulator mode" >> $LOG
    echo "" >> $LOG
    accumulator
    $bb sleep 30
    fi
    # Check battery status
    battery_status
    if [ "$BATT_STATUS" = "Charging" ]; then
    echo "[*] Device is being charged, applied Accumulator mode to reduce battery cycles for better battery backup." >> $LOG
    echo "" >> $LOG
    accumulator
    $bb sleep 60
    fi
    # Check battery %
    battery_percentage
    if [ "$BATT_LVL" -eq "25" ]; then
    echo "[*] Battery has reached 25%, applied Accumulator mode to prolong juicy battery backup." >> $LOG
    echo "" >> $LOG
    accumulator
    elif [ "$BATT_LVL" -eq "5" ]; then
    echo "[*] Battery is about to die, only 5% remaining." >> $LOG 
    echo "" >> $LOG
    else
    echo "[*] No heavy or noticeable usage found, applied Equalizer mode." >>  $LOG
    echo "" >> $LOG
    _equalizer
    $bb sleep 60
    fi
    # Check ram info
    ram_info
    if [ "$AVAIL_RAM" -le "$FULL_RAM" ]; then
    echo "[*] RAM is full, cleared RAM caches." >> $LOG
    echo "" >> $LOG
    $bb sync
    echo "3" > "/proc/sys/vm/drop_caches"
    fi
    # Check for running games
    for gpid in $($bb $bb pgrep -f netease) $($bb pgrep -f tipsworks) $($bb pgrep -f studiowildcard) $($bb pgrep -f wardrumstudios) $($bb pgrep -f ExiliumGames) $($bb pgrep -f com2us) $($bb pgrep -f zuuks) $($bb pgrep -f junegaming) $($bb pgrep -f pixelbite) $($bb pgrep -f junesoftware) $($bb pgrep -f sozap) $($bb pgrep -f dotemu) $($bb pgrep -f playables) $($bb pgrep -f playrisedigital) $($bb pgrep -f rockstar) $($bb pgrep -f blackpanther) $($bb pgrep -f noodlecake) $($bb pgrep -f linegames) $($bb pgrep -f kleientertainment) $($bb pgrep -f agaming) $($bb pgrep -f generagames) $($bb pgrep -f astragon) $($bb pgrep -f chucklefish) $($bb pgrep -f t2kgames) $($bb pgrep -f t2ksports) $($bb pgrep -f turner) $($bb pgrep -f uplayonline) $($bb pgrep -f pubg) $($bb pgrep -f dreamotion) $($bb pgrep -f snailgames) $($bb pgrep -f dexintgames) $($bb pgrep -f haegin) $($bb pgrep -f panzerdog) $($bb pgrep -f igg) $($bb pgrep -f gtarcade) $($bb pgrep -f naxon) $($bb pgrep -f mame4droid) $($bb pgrep -f kakaogames) $($bb pgrep -f telltalegames) $($bb pgrep -f seleuco) $($bb pgrep -f innersloth) $($bb pgrep -f kiloo) $($bb pgrep -f imaginalis) $($bb pgrep -f refuelgames) $($bb pgrep -f scottgames) $($bb pgrep -f clickteam) $($bb pgrep -f minigames) $($bb pgrep -f headupgames) $($bb pgrep -f mobigames) $($bb pgrep -f callofduty) $($bb pgrep -f ubisoft) $($bb pgrep -f ppsspp) $($bb pgrep -f cf) $($bb pgrep -f feralinteractive) $($bb pgrep -f riotgames) $($bb pgrep -f playgendary) $($bb pgrep -f joymax) $($bb pgrep -f deadeffect) $($bb pgrep -f blackdesertm) $($bb pgrep -f firsttouchgames) $($bb pgrep -f standoff2) $($bb pgrep -f criticalops) $($bb pgrep -f wolvesinteractive) $($bb pgrep -f gamedevltd) $($bb pgrep -f mojang) $($bb pgrep -f miHoYo) $($bb pgrep -f miniclip) $($bb pgrep -f moontoon) $($bb pgrep -f gameloft) $($bb pgrep -f netmarble) $($bb pgrep -f yoozoogames) $($bb pgrep -f eyougame) $($bb pgrep -f asphalt) $($bb pgrep -f dhlove) $($bb pgrep -f fifamobile) $($bb pgrep -f freefireth) $($bb pgrep -f activision) $($bb pgrep -f konami) $($bb pgrep -f gamevil) $($bb pgrep -f pixonic) $($bb pgrep -f gameparadiso) $($bb pgrep -f wargaming) $($bb pgrep -f madfingergames) $($bb pgrep -f supercell) $($bb pgrep -f allstar) $($bb pgrep -f garena) $($bb pgrep -f ea.gp) $($bb pgrep -f pixel.gun3d) $($bb pgrep -f titan.cd) $($bb pgrep -f rpg.fog) $($bb pgrep -f edkongames) $($bb pgrep -f ohbibi) $($bb pgrep -f apex_designs) $($bb pgrep -f roblox) $($bb pgrep -f halfbrick) $($bb pgrep -f maxgames) $($bb pgrep -f wildlife.games) $($bb pgrep -f blizzard); do
    if [ "$($bb grep -Eo "$gpid" "$toptsdir")" ] || [ "$($bb grep -Eo "$gpid" "$toptcdir")" ]; then
    echo "[*] Playing games, changed to Potency mode." >> $LOG
    echo "" >> $LOG
    potency
    $bb sleep 60
    fi
    done
    # Check for social apps
    for spid in $($bb pgrep -f whatsapp) $($bb pgrep -f musically) $($bb pgrep -f adobe) $($bb pgrep -f telegram) $($bb pgrep -f netflix) $($bb pgrep -f wemesh) $($bb pgrep -f discord) $($bb pgrep -f youtube) $($bb pgrep -f facebook) $($bb pgrep -f chrome) $($bb pgrep -f browser) $($bb pgrep -f instagram) $($bb pgrep -f docs) $($bb pgrep -f twitch); do
    if [ "$($bb grep -Eo "$spid" "$toptsdir")" ] || [ "$($bb grep -Eo "$spid" "$toptcdir")" ]; then
    echo "[*] Using social media and streaming apps, applied Equalizer mode." >> $LOG
    echo "" >> $LOG
    equalizer
    $bb sleep 60
    fi
    done
    # Check for benchmarking and heavy apps
    for bpid in $($bb pgrep -f geekbench) $($bb pgrep -f androbench2) $($bb pgrep -f kinemaster) $($bb pgrep -f futuremark) $($bb pgrep -f cputhrottlingtest) $($bb pgrep -f camera) $($bb pgrep -f cam) $($bb pgrep -f antutu); do
    if [ "$($bb grep -Eo "$bpid" "$toptsdir")" ] || [ "$($bb grep -Eo "$bpid" "$toptcdir")" ]; then  
    echo "[*] Using benchmarking and heavy apps, applied Output mode." >> $LOG
    echo "" >> $LOG
    output
    $bb sleep 60
    fi
    done
done
