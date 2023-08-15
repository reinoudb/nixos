#!/bin/bash

while true; do
  cpu_usage=$(top -bn 2 -d 0.5 | grep '^%Cpu' | tail -n 1 | awk '{print $2+$4}')
  echo "CPU $cpu_usage%"
  sleep 5
done
