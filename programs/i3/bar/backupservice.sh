#!/bin/bash

# Get the status of the borgbackup service
status=$(systemctl status borgbackup-job-home-dir.service | grep -oP '(?<=Active: ).*(?= since)' | awk '{print $1}')

# Check the status and set the color accordingly
if [[ $status == "failed" ]]; then
    color="#FF0000"  # Red for failed
else
    color="#FFFFFF"  # White for other statuses
fi

# Output the status in JSON format for i3bar
echo "{\"name\":\"borgbackup\",\"full_text\":\"BorgBackup: $status\",\"color\":\"$color\"}"


