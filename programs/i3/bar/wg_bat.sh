#!/bin/sh 

i3status -c /config/i3/bar/i3status.main.conf | while :
# i3status | while :
do

  stor_perc=$(df -h / | awk 'NR==2 {print $5}')
  
  batterij=$(cat /sys/class/power_supply/BAT1/capacity)
  batterij_status=$(cat /sys/class/power_supply/BAT1/status)

  if [ $batterij_status == "Discharging" ]; then
    status="BAT"
  else
    status="CHR"
  fi
  batterij_volledig="$status: $batterij%"
  if [ $batterij -qt 99 ]; then
    batterij_volledig="FULL"
  fi

wg=$(ifconfig | grep -o 'wg[0-9]*')

if [ -z "$wg" ]; then
  vpn=""
else
  vpn=""
fi
  
  read line
  echo "$vpn | $stor_perc | $batterij_volledig | $line" || exit 1
done

