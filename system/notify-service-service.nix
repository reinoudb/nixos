{ config, pkgs, ... }:

let
    bat_files = "/sys/class/power_supply/BAT1";
    bat_status = builtins.readFile "${bat_files}/status";
    capacity = builtins.readFile "${bat_files}/capacity";
in
{
  services.xserver = {
    enable = true;
    # Configure your X11 settings here if needed
  };

  systemd.user.services = {
    battery = {
      description = "Send a test notification";
      script = ''
      ${pkgs.bash}/bin/bash
        # Use notify-send to send a test notification

        if [[ ${bat_status} == "Discharging" && ${capacity} -lt 28 && ${capacity} -gt 15 ]]; then
          echo "Battery alert - ${capacity}%"
          ${pkgs.libnotify}/bin/notify-send "Low Battery Level" "Only ${capacity} left" --icon=./low-battery.png --urgency normal
        fi

        if [[ ${bat_status} == "Discharging" && ${capacity} -lt 15 ]]; then
          echo "Battery alert - ${capacity}%"
          ${pkgs.libnotify}/bin/notify-send "Low Battery Level" "Only ${capacity}" --icon=./low-battery.png --urgency critical
          sleep 60
          ./alert-battery.sh
        fi

        if [[ ${capacity} -gt 95 ]]; then
          echo "Battery alert - ${capacity}%"
          ${pkgs.libnotify}/bin/notify-send "Battery full" --icon=./full-battery.png --urgency low
        fi

        echo $capacity
        ${pkgs.libnotify}/bin/notify-send "test"
      '';
      wantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers = {
    test-notification-timer = {
      enable = true;
      timerConfig = {
        OnBootSec = "1min";    # Start the timer 1 minute after boot
        OnUnitActiveSec = "5m";  # Trigger the unit every 1 minute
        Unit = "battery.service";
      };
    };
  };
}





















# { config, pkgs, ... }:

# {
#   services.xserver = {
#     enable = true;
#     # Configure your X11 settings here if needed
#   };

#   systemd.user.services = {
#     battery-alert = {
#       description = "Send a test notification";
#       script = ''
#         # Use notify-send to send a test notification
#         ${pkgs.bash}/bin/bash
#           pushd ~/.dotfiles/scripts/battery/
#             bat_files="/sys/class/power_supply/BAT1"
#             bat_status=$(cat "${bat_files}/status")
#             capacity=$(cat "${bat_files}/capacity")


#             if [[ ${bat_status} == "Discharging" && ${capacity} -lt	28 && ${capacity} -gt 15 ]]; then
#                 echo "Battery alert - ${capacity}%"
#                 ${pkgs.libnotify}  "Low Battery Level" "Only ${capacity} left" --icon=./low-battery.png --urgency normal
#             fi




#             if [[ ${bat_status} == "Discharging" && ${capacity} -lt 15 ]]; then
#                   echo "Battery alert - ${capacity}%"
#                   notify-send  "Low Battery Level" "Only ${capacity}" --icon=./low-battery.png --urgency critical
#                 sleep 60
#                 ./alert-battery.sh
#             fi




#             if [[ ${capacity} -gt 95 ]]; then
#                   echo "Battery alert - ${capacity}%"
#                   notify-send  "Battery full" --icon=./full-battery.png --urgency low
#             fi

#             echo $capacity
#             notify-send "test"
#             popd


#        # ${pkgs.libnotify}/bin/notify-send "Test Notification" "This is a test notification from NixOS."
#       '';
#       wantedBy = [ "default.target" ];
#     };
#   };

#   systemd.user.timers = {
#     test-notification-timer = {
#       enable = true;
#       timerConfig = {
#         OnBootSec = "1min";    # Start the timer 1 minute after boot
#         OnUnitActiveSec = "5m";  # Trigger the unit every 1 minute
#       Unit = "battery-alert.service";
#       };
#     };
#   };
# }

