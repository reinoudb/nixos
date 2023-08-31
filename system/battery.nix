{ config, pkgs, ...}:

let
  bat_files = "/sys/class/power_supply/BAT1";
  bat_status = builtins.readFile "${bat_files}/status";
  capacity = builtins.readFile "${bat_files}/capacity";
  libnotify = pkgs.libnotify;
in
  if builtins.stringEquel bat_status "Charging" then
  /bin/notify-send "if"
  else
  /bin/notify-send "if"
