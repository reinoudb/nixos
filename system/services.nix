{ config, pkgs, ... }:

let
  libnotify = pkgs.libnotify;  # Replace 'libnotify' with the actual package name
  bash = pkgs.bash;
in

{
  systemd.user = {
    services = {
      test = {
        enable = true;
        description = "test notification for me";
        serviceConfig = {
          # ExecStart = "${libnotify}/bin/notify-send test --urgency critical";
          # ExecStart = "/home/reinoud/.dotfiles/scripts/battery/alert-battery.sh";
          Type = "simple";
        };
        serviceConfig.ExecStart = echo "test";
        wantedBy = [ "multi-user.target" ];
      };
    };
  };

systemd.user.timers = {
  test = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "5m";
      Unit = "test.service";
    };
  };
};



}

