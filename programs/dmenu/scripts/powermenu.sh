#!/bin/sh


choises="Lock\nLogout\nSleep\nHibernate\nReboot\nShutdown"

keuze=$(echo -e "$choises" | dmenu -i)
case "$keuze" in
  Lock) i3lock -u -i /home/reinoud/Pictures/wallpaper/nix-wallpaper-stripes-logo.png -t -e;;
  Logout) pkill -KILL -u $(whoami);;
  Sleep) systemctl suspend;;
  Hibernate) systemctl hibernate;;
  Reboot) reboot;;
  Shutdown) shutdown now;; 
esac
