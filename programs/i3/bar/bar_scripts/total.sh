#!/bin/bash

while true; do
  cpu_usage=$(top -bn 2 -d 0.5 | grep '^%Cpu' | tail -n 1 | awk '{print $2+$4}')
  used_memory=$(free -h | awk '/^Mem/ {print $3}')

  battery_charging=""
  battery_percentage=""

  # Fetch battery information only if available
  if [ -e "/sys/class/power_supply/BAT1/status" ] && [ -e "/sys/class/power_supply/BAT1/capacity" ]; then
    battery_status=$(cat /sys/class/power_supply/BAT1/status)
    battery_percentage=$(cat /sys/class/power_supply/BAT1/capacity)

    # Determine the battery charging status
    if [ "$battery_status" == "Charging" ]; then
      battery_charging=" Charging"
    else
      battery_charging=""
    fi
  fi

  # Fetch Wi-Fi connection information
  wifi_ssid=$(nmcli -t -f active,ssid dev wifi | awk -F ':' '$1=="yes" {print $2}')
  wifi_ip_address=$(ip addr show dev wlo1 | awk '/inet / {print $2}' | cut -d '/' -f 1)

  if [ -z "$wifi_ssid" ]; then
    wifi_ssid="Disconnected"
  fi

  tijd=$(date +"%H:%M %d-%m-%g")

  geluid=$(pactl list sinks | grep -A 15 'RUNNING' | grep 'Volume:' | awk '{print $5}' | head -1)

  echo "$wifi_ssid | $battery_charging $battery_percentage% | $geluid | CPU: $cpu_usage% | RAM: $used_memory | $tijd"
  sleep 5
done

