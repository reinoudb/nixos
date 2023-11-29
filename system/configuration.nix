# Edit this configuration file to define what should be installed on # your system.  Help is available in the configuration.nix(5) man page
## and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:


{

imports = [
  ./hardware-configuration.nix
  ./pkgs.nix
];

nix = {
  gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes"; 
};

system = {
  stateVersion = "23.05";
  autoUpgrade.enable = true;
  autoUpgrade.allowReboot = false;
};

boot = { 
  loader.systemd-boot.enable = true;
  loader.efi.canTouchEfiVariables = true;
  supportedFilesystems = [ "ntfs" ];
};

fonts.fonts = with pkgs; [
  font-awesome_5
  nerdfonts
];

networking = {
  hostName = "nixos";
  networkmanager.enable = true;
  firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
      5357
    ]; 
  };
};

time.timeZone = "Europe/Brussels";
console.keyMap = "be-latin1";

i18n.defaultLocale = "en_US.UTF-8";

users = {
  groups.nixosvmtest = {};
  defaultUserShell = pkgs.fish;
  users = {
    nixosvmtest.group = "nixosvmtest";
    nixosvmtest.isSystemUser = true;
    nixosvmtest.initialPassword = "test";
    reinoud = {
      hashedPassword = "$y$j9T$B/YmFB8FMAe.4uxr7fCKr/$Imn1somsWGrCa43aMzBURbmai5hwFALVkDxXcECm7x/";
      isNormalUser = true;
      description = "reinoud";
      extraGroups = [ 
        "wireshark"
        "kvm"
        "networkmanager"
        "wheel"
        "libvirtd"
        "audio"
        "dbus"
        "tss" #tpm
      ];
    };
  };
}; 

nixpkgs.config.allowUnfree = true;

xdg.portal = {
  enable = true;
  extraPortals = [
    pkgs.xdg-desktop-portal-kde 
  ];
};

virtualisation = {
  libvirtd.enable = true;
  podman.enable = true;
  vmware.host.enable = true;
};

programs = {
  steam.enable = true;
  xss-lock = {
    enable = true; 
  };
  i3lock.enable = true;
  ssh.knownHosts = {
      myhost = {
        extraHostNames = [ "192.168.0.125" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCk74I9ZaUUFUsDhMcZllvsD418Po4d4mR0rTMFVTMhy7kFIUAqcoAUSCnZHO7ROrTAUhmgqlBpwvYFBo9Dpr7Zf8PV2tPu2avw8Gan1pfDE7FTQitVaUqOdtoe+Km+gTdaCZLTg3W+KJ+4+TRg+7PqrYiWwIlAsMUjmWDr4nYArJplqYFTpVuWzLjZmiADW0AD/bJmw0P7+lZmcLrgUkXUoEH12ZOdTp4g+bAe7CSqEK5I3Ao1eWluydk425oBhF2Wd0cVBShnfMN3fdxWm0Bkg/W0daeHM1kZ9cXzZwtcVInJz7NYxnP3iUA4QQ3xL2lCg/ZF0Z+n0QKSH+12AtPCvoOXXIBYqYf0bUt7U9IsTvJ3gmWW2W4yDgVWTHoFGKnkWMXy3svgf0f1+BMv6EE+cQ/O9FehiJwX1YasYISXbAxqgyt2M5lg3QLP7b9tLMgvghSddTg9olZBZ3cgtT9/jEEHiZzGxaGlNmFuLhZoU7RyvzequHfnb5aLqXkDb6c=";
      };
    };
	dconf.enable = true;
	vim.defaultEditor = true;
  fish = {
    enable = true;
    promptInit = "test"; 
    shellInit = "set -U fish_greeting"; # what to launch when terminal started
    loginShellInit = "date";
    # interactiveShellInit = "shuf -n 1 /home/reinoud/scripts/facts";
    interactiveShellInit = "";
    shellAliases = {
      plutomooimaken="sudo nix-collect-garbage --delete-older-than 2d && applysystem";
      ap="cd ~/Documents/ap";
      dot="cd /home/reinoud/.dotfiles/"; 
      applysystem="bash /home/reinoud/.dotfiles/apply-system.sh";
      applyuser="bash /home/reinoud/.dotfiles/apply-users.sh";
      dup="bash /home/reinoud/scripts/duplicate.sh";
    };
  };
  thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin 
      thunar-volman
      thunar-media-tags-plugin 
    ];
  };
};

powerManagement.enable = true;
services = { 
  ratbagd.enable = true;
  geoclue2.enable = true;
  redshift = {
    enable = true;
    brightness = {
      day = "1";
     night = "1";
    }; 
    temperature = {
      day = 5500;
      night = 3700;
    };
  };
  fail2ban = {
    enable = true;
   maxretry = 5; # Observe 5 violations before banning an IP
    ignoreIP = [
      # Whitelisting some subnets:
      "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16"
      "8.8.8.8" # Whitelists a specific IP
      "nixos.wiki" # Resolves the IP via DNS
    ];
    bantime = "24h"; # Set bantime to one day
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
    jails = {
      ssh = ''
        enabled = true
        filter = sshd
        logpath = /var/log/auth.log
        bantime = 3600
        findtime = 600
        maxretry = 3
        action = iptables-multiport[name=sshd, port="ssh", protocol=tcp]
      '';
      samba = ''
        enabled = true
        filter = samba
        logpath = /var/log/samba/log.*
        bantime = 3600
        findtime = 600
        maxretry = 5
        action = iptables-multiport[name=samba, port="139,445", protocol=tcp]
      '';
    };
  };
  samba-wsdd.enable = true; # make share visible win10
  samba = {

    enable = true;
    enableNmbd = false;
    enableWinbindd = false;
    extraConfig = ''
      map to guest = Bad User

      load printers = no
      printcap name = /dev/null

      log file = /var/log/samba/client.%I
      log level = 2
    '';

    shares = {
      private = {
        browseable = "yes";
        path = "/mount/share/";
        "guest ok" = "no";
        "read only" = "no";
        "force user" = "reinoud"; # als iemand wilt verbinden moet die username dit zijn
        "create mask" = "0700";
        "directory mask" = "0700";
        
      };
    };
  };
  locate = {
    enable = true;
    interval = "hourly"; # when to update db 
  };
  thermald.enable = true;
  tlp.enable = true;
  auto-cpufreq = { 
    enable = true;
    settings = {
      battery = {
      governor = "powersave";
      turbo = "never";
      };
      charger = {
      governor = "performance";
      turbo = "auto";
      };
    };
  };
  borgbackup.jobs.home-dir = {
    persistentTimer = true;
    exclude = [
      "/home/*/.local/share/Steam"
      "/home/*/mount"
      "/home/*/Games" 
      ".cache"
      "*/basestation"
    ];
    patterns = [ # Include/exclude paths matching the given patterns. The first matching patterns is used, so if an include pattern (prefix +) matches before an exclude pattern (prefix -), the file is backed up. See borg help patterns for pattern syntax.
        
    ];
    paths = [
      "/home/" 
      "/config"
    ];
    encryption = {
      mode = "keyfile";
      passCommand = "cat /home/reinoud/.dotfiles/secrets/borg/password";
      };
    environment.BORG_RSH = "ssh -i /home/reinoud/.ssh/id_rsa";
    repo = "ssh://reinoud@192.168.0.125:57130/mnt/2tb/backup/nixos";
    compression = "auto,zstd";
    startAt = "hourly";
    prune.keep = {
      within = "1d";
      daily = 7;
      weekly = 4;
      monthly = 12;
      yearly = 5;
    };
  };    
  dbus.enable = true;
  openssh.enable = true;
	pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true; };
	flatpak.enable = true;
	xserver = { 
    enable = true;
    libinput.mouse = {
      accelProfile = "flat";
      accelSpeed = "1.15";
    };
		layout = "be";
		xkbVariant = "";
    windowManager = {
      dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs {
            src = ./../programs/dwm; 
        }; 
      };
      i3 = {
        enable = true;
      };
		};
  };    
	blueman.enable = true;
  picom.enable = true;
  #thunar related
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
};

systemd.user = {
  timers = {
    battery-alert = {
      enable = true;
      description = "Battery Alert Timer";
      timerConfig = {
        OnActiveSec = "1m";
        OnStartupSec = "1m";
        RemainAfterElapse= true;
        OnUnitActiveSec = "1m";
        Unit = "battery-alert.service";
      };
      wantedBy = [ "default.target" ];
    };
  };
  services = {
    lxpolkit = {
      description = "lxde polkit";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lxde.lxsession}/bin/lxpolkit";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    battery-alert = {
      enable = true;
      path = with pkgs; [ bash libnotify ];
      description = "Battery Alert Service";
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash /home/reinoud/.dotfiles/scripts/battery/alert-battery.sh";
          Environment = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus";
        Type = "simple";
      };
      wantedBy = ["default.target"]; 
    };
	};
};

 hardware = {
  uinput.enable = true; # iets voor xremap 
  bluetooth.enable = true;
};

specialisation = { 
   nvidia.configuration = { 
     services.xserver.videoDrivers = [ "nvidia" ]; 
     hardware.opengl.enable = true; 
     hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable; 
     hardware.nvidia.modesetting.enable = true; 
     hardware.nvidia.prime = { 
       sync.enable = true; 
       nvidiaBusId = "PCI:1:0:0"; 
       intelBusId = "PCI:0:2:0"; 
     };
  };
};

security = {
  # sudo = {
  #   enable = true;
  #   extraRules = [{
  #     commands = [
  #       {
  #         command = "${pkgs.wg_quick}/bin/wg-quick";
  #         options = ["NOPASSWD"];
  #         args = ["ALL"];
  #       } 
  #     ]; 
  #     groups = [ "wheel" ];
  #   }]; 
  # };
  rtkit.enable = true;
  tpm2 = {
    enable = true;
    pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  };
};

location.provider = "geoclue2";

# systemd.services = {
#   borgbackup-job-home-dir.serviceConfig = {
#     # ProtectHome = "read-only";
#     # PrivateUsers = true;
#     ProtectKernelLogs = true;
#     ProtectHostname = true;
#     RestrictSUIDSGID = true;
#     NoNewPrivileges = true;
#     PrivateDevices = true;
#     RestrictAddressFamilies = "AF_UNIX AF_INET";
#     ProtectKernelTunables = true; 
#   };
# };
}
