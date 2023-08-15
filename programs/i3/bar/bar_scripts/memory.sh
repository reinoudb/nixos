#!/bin/bash

while true; do
  used_memory=$(free -h | awk '/^Mem/ {print $3}')
  echo "Memory Used: $used_memory"
  sleep 5
done

