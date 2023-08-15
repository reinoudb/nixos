#!/bin/sh


while true
do
  datum=$(date +"%b %m %H:%M")
  volume=$(amixer sget Master | awk -F"[][]" '/Left:/ { print $2 }')
  batterij=$(cat /sys/class/power_supply/BAT1/capacity)
  batterij_status=$(cat /sys/class/power_supply/BAT1/status)
if [ $batterij_status == "Discharging" ]; then
  status="BAT"
else
  status="CHR"
fi
batterij_volledig="$status: $batterij%"
if [ $batterij -gt 99 ]; then
  batterij_volledig="FULL"
fi




wifi=$(iwgetid -r)
wg_status=$(wg show)
if [ "$wg_status" = "" ];
then
  wg="Dis"
else
  wg="Con"
fi

echo "$wg | $wifi | $batterij_volledig | VOL: $volume | $datum"
sleep 3
done
