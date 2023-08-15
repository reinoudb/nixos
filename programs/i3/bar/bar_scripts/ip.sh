#!/bin/bash 

while true; do
  echo $(hostname -I | grep -oP '(\d+\.){3}\d+')
  sleep 5
done

