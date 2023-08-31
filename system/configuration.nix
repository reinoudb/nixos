# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
## and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./unstable.nix
      # <home-manager/nixos>
      # ./borgbackupMonitor.nix
      #./vim.nix
      # ./notify-service-service.nix
      # ./services.nix
    ];

    nix = {
      package = pkgs.nixFlakes;
     extraOptions = "experimental-features = nix-command flakes"; 
    };
 
system = {
  stateVersion = "23.05"; # Did you read the comment?
  autoUpgrade.enable = true;
  autoUpgrade.allowReboot = false; # true
};
   

boot = { 
  plymouth.enable = true;
  loader.systemd-boot.enable = true;
  loader.efi.canTouchEfiVariables = true;
  supportedFilesystems = [ "ntfs" ];
#Setup keyfile 
  initrd.secrets = {
    "/crypto_keyfile.bin" = null;
        };
};

fonts.fonts = with pkgs; [
  font-awesome_5
  nerdfonts
];

networking = {
  hostName = "nixos";
  networkmanager.enable = true;
  nameservers = [ "9.9.9.9" ];
 #wireless.enable = true; # enable wireless support via wpa_supplicant
   wg-quick.interfaces = { #/
     wg0 = { #/
       address = [ "10.147.94.120/32" "fd7d:76ee:e68f:a993:68bb:339:f2ff:8a29/128" ]; #/
       dns = [ "10.128.0.1" "fd7d:76ee:e68f:a993::1" ]; #/
       privateKeyFile = "/config/wireguard/privatekey"; #/

      peers = [ #/
         { #/
         publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk="; #/
         presharedKeyFile = "/config/wireguard/presharedKeyFile"; #/
         allowedIPs = [ "0.0.0.0/0" "::/0" ]; #/
         endpoint = "nl.vpn.airdns.org:1637"; #/
         persistentKeepalive = 15; #/
         } #/
       ]; #/
     }; #/
   }; #/
};

time.timeZone = "Europe/Brussels";
console.keyMap = "be-latin1";

  # Select internationalisation properties.
i18n.defaultLocale = "en_US.UTF-8";

users = {
  defaultUserShell = pkgs.fish;
  users.reinoud = {
    isNormalUser = true;
    description = "reinoud";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "audio" "dbus" ];
    packages = with pkgs; [];
  };
};

nixpkgs.config.allowUnfree = true;


environment.systemPackages = with pkgs; [

lxappearance # change icon & themes i3
i3
i3lock-fancy-rapid
x11basic
xdg-desktop-portal-gnome
i3status
lightdm
i3blocks

# audio
  blueman # bluetooth
  pulseaudioFull
  alsa-utils

# core
xvfb-run
xautolock
unrar-wrapper
dig
#wpa_supplicant_gui
sshfs
psmisc
linuxKernel.packages.linux_zen.cpupower # set cpu performance
  cargo
  tmux
  findutils
  mlocate
  gnome.zenity
  bash
  python3Full
  wireguard-tools

  wget
  zip
  unzip
  htop
  libnotify
  brightnessctl
  playerctl
  git
  cryptsetup
  polkit_gnome
  lsof # volume control²
  dunst
  p7zip
  ntfs3g
  arandr
  android-udev-rules
  ncdu
  podman
  distrobox
  wirelesstools

# gaming
vulkan-tools
vulkan-loader
steam-run
protontricks
winetricks
steam
lutris
  #jc141
  perl536Packages.OpenGL
    wineWowPackages.unstableFull
    dwarfs
    /* wine-staging */
    fuse-overlayfs
	vitetris

# virtual
	virt-manager
  # vmware-workstation
  # linuxKernel.packages.linux_zen.vmware
  # linuxKernel.packages.linux_xanmod_stable.vmware
  qemu_full

    btop 
    xfce.xfce4-screenshooter
    alacritty
    gimp
    iamb
    matrixcli
    nheko
    gimp
    russ # rss
    gpicview 
    vlc
    haskellPackages.subnet
    pro-office-calculator
    qbittorrent
    rclone
    feh
	vim-full
    xcolor
    mysql80
    #ciscoPacketTracer8 
    xfce.thunar
    thunderbird
    filezilla
    wireshark
    pipe-viewer
    dolphin
    j4-dmenu-desktop
    spotify
    fish
    neofetch
    keepassxc
    signal-desktop
    gparted
    rofi
    rofi-vpn
    rofi-calc
    rofi-power-menu
    vorta
    borgbackup
    electron-mail
    onlyoffice-bin
    kate
    element-desktop
    ranger
# browser
    librewolf
    tor-browser-bundle-bin 
    tor
    brave
    firefox
  ];
#};

  # Some rograms need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];

virtualisation = {
  libvirtd.enable = true;
  # vmware.host.enable = true;
};

programs = {
  i3lock.enable = true;
  ssh.knownHosts = {
      myhost = {
        extraHostNames = [ "192.168.0.125" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCk74I9ZaUUFUsDhMcZllvsD418Po4d4mR0rTMFVTMhy7kFIUAqcoAUSCnZHO7ROrTAUhmgqlBpwvYFBo9Dpr7Zf8PV2tPu2avw8Gan1pfDE7FTQitVaUqOdtoe+Km+gTdaCZLTg3W+KJ+4+TRg+7PqrYiWwIlAsMUjmWDr4nYArJplqYFTpVuWzLjZmiADW0AD/bJmw0P7+lZmcLrgUkXUoEH12ZOdTp4g+bAe7CSqEK5I3Ao1eWluydk425oBhF2Wd0cVBShnfMN3fdxWm0Bkg/W0daeHM1kZ9cXzZwtcVInJz7NYxnP3iUA4QQ3xL2lCg/ZF0Z+n0QKSH+12AtPCvoOXXIBYqYf0bUt7U9IsTvJ3gmWW2W4yDgVWTHoFGKnkWMXy3svgf0f1+BMv6EE+cQ/O9FehiJwX1YasYISXbAxqgyt2M5lg3QLP7b9tLMgvghSddTg9olZBZ3cgtT9/jEEHiZzGxaGlNmFuLhZoU7RyvzequHfnb5aLqXkDb6c=";
      };
    };
	dconf.enable = true;
	vim.defaultEditor = true;
	fish.enable = true;
  thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin 
      thunar-volman
      thunar-media-tags-plugin 
    ];
  };
};

# Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
#sound.enable = false;
# rtkit is optional but recommended security.rtkit.enable = true; 
security.rtkit.enable = true;
services = { 
    dbus.enable = true;
  openssh.enable = true;
	pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true; };
	flatpak.enable = true;
	xserver = { 
		xautolock = {
      enable = true;
      time = 1;
      # enableNotifier = true;
      notify = 5;
      locker = "${pkgs.lightdm}/bin/lightdm";
    };
    enable = true;
		windowManager.i3.configFile = ./../programs/i3/config;
		layout = "be";
		xkbVariant = "";
    windowManager.i3.enable = true;

		};
	blueman.enable = true;
  picom.enable = true;
  #thunar related
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    };

/*
home-manager.useGlobalPkgs = true;
home-manager.users.reinoud = { pkgs, ...}: {
	home.stateVersion = "23.05";
	home.packages = with pkgs; [
				];

  #home.file.".vim" = {
  #	source = /config/vim;
  #	recursive = true;
  #	};
};
*/


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


       polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; Restart = "on-failure"; RestartSec = 1; TimeoutStopSec = 10; 
          };
    };
	};
};

 hardware = {
 bluetooth.enable = true;
};

services.borgbackup.jobs.home-dir = {
  paths = "/home/reinoud/Documents";
  encryption = {
    mode = "keyfile";
    passCommand = "cat /config/borg/password";
    };
  environment.BORG_RSH = "ssh -i /home/reinoud/.ssh/id_rsa";
  repo = "ssh://reinoud@192.168.0.125:57130/mnt/2tb/backup/nixos";
  compression = "auto,zstd";
  startAt = "hourly";
};

nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 15d";
};

fileSystems."/home/reinoud/basestation" = {
  device = "local-basestation:/mnt/2tb/Documents";
  fsType = "sshfs";
  options =
    [ # Filesystem options
      "allow_other"          # for non-root access
      "_netdev"              # this is a network fs
      "x-systemd.automount"  # mount on demand

      # SSH options
      "reconnect"              # handle connection drops
      "ServerAliveInterval=15" # keep connections alive
    ];
};
}
