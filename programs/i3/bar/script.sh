#!/usr/bin/env bash

# This i3status wrapper allows to add custom information in any position of the statusline
# It was developed for i3bar (JSON format)

# The idea is to define "holder" modules in i3status config and then replace them

# In order to make this example work you need to add
# order += "tztime holder__hey_man"
# and 
# tztime holder__hey_man {
#        format = "holder__hey_man"
# }
# in i3staus config 

# Don't forget that i3status config should contain:
# general {
#   output_format = i3bar
# }
#
# and i3 config should contain:
# bar {
#   status_command exec /path/to/this/script.sh
# }

# Make sure jq is installed
# That's it

# You can easily add multiple custom modules using additional "holders"

function update_holder {

  local instance="$1"
  local replacement="$2"
  echo "$json_array" | jq --argjson arg_j "$replacement" "(.[] | (select(.instance==\"$instance\"))) |= \$arg_j" 
}

function remove_holder {

  local instance="$1"
  echo "$json_array" | jq "del(.[] | (select(.instance==\"$instance\")))"
}

function hey_man {

  status=$(systemctl status borgbackup-job-home-dir.service | grep -oP '(?<=Active: ).*(?= since)' | awk '{print $1}')

  if [ $status == "failed" ] ; then
    local json='{ "full_text": "BAK: failed", "color": "#FF0000" }'
    json_array=$(update_holder holder__hey_man "$json")
  elif [ $status == "active" ]; then
    local json='{ "full_text": "BAK: running", "color": "#FFFFFF" }'
    json_array=$(update_holder holder__hey_man "$json")
  else
    local json='{ "full_text": "BAK: inactive", "color": "#FFFFFF" }'
    json_array=$(update_holder holder__hey_man "$json")
  fi

}

i3status -c ~/.dotfiles/programs/i3/bar/i3status.main.conf | (read line; echo "$line"; read line ; echo "$line" ; read line ; echo "$line" ; while true
do
  read line
  json_array="$(echo $line | sed -e 's/^,//')"
  hey_man
  echo ",$json_array" 
done)
