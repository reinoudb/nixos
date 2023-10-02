#!/bin/sh 

i3status -c /config/i3/bar/i3status.main.conf | while :
# i3status | while :
do
  
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

wg=$(ifconfig | grep -o 'wg[0-9]*')


  stor_perc=$(df -h / | awk 'NR==2 {print $5}')
  storage="DF: $stor_perc"

  if [[ $(cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor) = "powersave" ]]; then
    cpu="pwrs"
  else
    cpu="perf"
  fi
  
  read line
  echo "$batterij_volledig | $storage | $line" || exit 1
done

