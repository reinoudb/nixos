#!/bin/sh

gamedir="$HOME/Games"
games=$(ls $gamedir)

keuze=$(echo -e "$games" | dmenu -i -p "Choose your game")

if [ -n "$keuze" ]; then
  cd "$games_dir/$keuze"
  start_script=$(ls start*)

  if [ -n "$start_script" ]; then
    bash "$start_script"
  else
    echo -e "ok" | dmenu -i -p "No start script found in the chosen game directory."
  fi
else
  echo "no game selected"
fi
