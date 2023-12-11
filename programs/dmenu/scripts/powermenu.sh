#!/bin/bash


choises="Lock\nLogout\nSleep\nHibernate\nReboot\nShutdown"

keuze=$(echo -e "$choises" | dmenu -i)
case "$keuze" in
  Lock) i3lock;;
  Logout) pkill -KILL -u $(whoami);;
  Sleep) systemctl suspend;;
  Hibernate) systemctl hibernate;;
  Reboot) reboot;;
  Shutdown) shutdown now;; 
esac
