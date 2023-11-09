#!/bin/sh
xrandr | grep " connected" | awk '{print $1}' > .displays
displaytomount=$(tail -n -1 .displays)

if [[ $displaytomount  = "eDP-1" ]]; then
  choices="ok\nmanual"
  keuze=$(echo -e "$choices" | dmenu -i -p "$displaytomount is alleen")
  case "$keuze" in
    ok) exit;;
    manual) arandr;;
  esac
fi

choices="left\nright\nmanual"
chosen=$(echo -e "$choices" | dmenu -i -p "Where to set $displaytomount")

case "$chosen" in
    left) positions=left;;
    right) positions=right;;
    manual) arandr;; 
esac


if [[ $chosen != "manual" ]]; then
  xrandr --output $displaytomount --$positions-of $(head -n 1 .displays) 
  echo "test"
fi
