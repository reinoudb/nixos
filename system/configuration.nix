{ pkgs, inputs, config, ... }:
{

imports = [
  ./hardware-configuration.nix
  ./pkgs.nix
  inputs.nixvim.nixosModules.nixvim
];

documentation.nixos.enable = false;
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
  stateVersion = "23.11";
  autoUpgrade.enable = true;
  autoUpgrade.allowReboot = false;
};

boot = { 
  tmp.cleanOnBoot = true;
  loader = {
    timeout = 2;
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
  supportedFilesystems = [ "ntfs" ];
};

fonts.packages = with pkgs; [
  font-awesome_5
  nerdfonts
];

networking = {
  hosts = {
    "10.133.0.2" = ["vcenter.bletchley.ap.be"];
    "10.133.0.22" = ["esxi.snb.lab"];
  };
  hostName = "nixos";
  networkmanager.enable = true;
  # wireless = {
  #   enable = true;
  #  userControlled.enable = true; 
  # };
  firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
    ]; 
  };
};

time.timeZone = "Europe/Brussels";
console.keyMap = "be-latin1";

i18n.defaultLocale = "en_US.UTF-8";

environment.variables = {
  TERM = "alacritty";
};

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
        "docker"
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
  config.common.default = "kde";
};

virtualisation = {
  docker = {
    enable = true;
    rootless = {
      enable = true;
     setSocketVariable = true; 
    };
  };
  virtualbox.host.enable = true;
  libvirtd.enable = true;
  vmware.host.enable = true;
};

programs = {
  nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    # globals.mapleader = ","; # set leader key to ,
    options = { # get them from :h option-list
      mouse = false;
      mousehide = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2; # tab widht
      cursorline = true;
      errorbells = false;
      smarttab = true;
      expandtab = true;
      smartindent = true;
      wrap = true;
      smartcase = true;
      swapfile = false;
      backup = false;
      incsearch = true;
      history = 5000;
      background = "dark";
      wildmenu = true;
      ignorecase = true;
      undodir = "/home/reinoud/.vim/undodir";
      undofile = true;
      clipboard = "unnamedplus";
    };
    plugins = {
      neo-tree = {
        enable = true;
        enableGitStatus = true;
        enableModifiedMarkers = true;
        enableRefreshOnWrite = true;
        closeIfLastWindow = true;
        defaultSource = "filesystem";
        sortCaseInsensitive = true;
      };
      comment-nvim.enable = true;
      better-escape.enable = true;
      auto-save.enable = true;
      lightline.enable = true; 
      nix.enable = true;
      nvim-autopairs.enable = true; 
      fugitive.enable = true;
      gitgutter = {
        enable = true;
        matchBackgrounds = true;
      };
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true; 
          pyright.enable = true;
        };
      }; 
    };
    extraPlugins = [
      pkgs.vimPlugins.ansible-vim
      pkgs.vimPlugins.plenary-nvim
      pkgs.vimPlugins.nvim-web-devicons
      pkgs.vimPlugins.nui-nvim
    ];
  # extraConfig = ''
	# " Persistent_undo
	# set undodir=~/.vim/undodir"
	# set undofile
	# let g:undotree_WindowLayout = 2
  # '';
  };
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
      xterm-kitty="kitty";
      cat="bat --paging=never";
      topdf="asciidoctor-pdf";
      gs="git status";
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
  avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
  printing.enable = true;
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
    user = "reinoud";
    group = "users";
    persistentTimer = true;
    exclude = [
      "/home/*/mount"
    ];
    paths = [
      "/home/reinoud" 
      "/mount/share"
    ];
    encryption = {
      mode = "keyfile";
      passCommand = "cat /home/reinoud/.dotfiles/secrets/borg/password";
      };
      environment = {
        BORG_RSH = "ssh -v -i /home/reinoud/.ssh/id_rsa";
        DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
        BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
      };
    doInit = false;
    repo = "ssh://public/mnt/2tb/backup/nixos";
    compression = "auto,zstd";
    startAt = "daily";
    prune.keep = {
      within = "3d";
      daily = 14;
      weekly = 8;
      monthly = 12;
      yearly = -1;
    };
    archiveBaseName = "${config.networking.hostName}";
    dateFormat = "+%Y-%m-%d-%H:%M:%S";
    postHook = ''
      if [ $exitStatus -eq 0 ]; then
        /run/current-system/sw/bin/notify-send "Backup" "Backup completed successfully." --urgency low
      else
        /run/current-system/sw/bin/notify-send  "Backup" "Backup failed with error." --urgency critical
      fi
    '';
    extraCreateArgs = "--stats --checkpoint-interval 300 --progress" ;
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
    borgbackup-job-home-dir = {
      serviceConfig = {
        StandardOutput = "journal";
        StandardError = "inherit";
      };
    };

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
  bluetooth.enable = true;
  uinput.enable = true;
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

  services.nfs.server.enable = true;

  # Add firewall exception for VirtualBox provider
  networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';

  # Add firewall exception for libvirt provider when using NFSv4
  networking.firewall.interfaces."virbr1" = {
    allowedTCPPorts = [ 2049 ];
    allowedUDPPorts = [ 2049 ];
  };

   users.extraGroups.vboxusers.members = [ "reinoud" ];

home-manager.users.reinoud = {
  home = {
    username = "reinoud";
    homeDirectory = "/home/reinoud";
    stateVersion = "23.11";

    packages = with pkgs; [
    
    ];

    file = {
      ".vimrc".source = ./../programs/vim/vimrc; 

      ".config/alacritty/alacritty.yml".text = ''
        colors:
          primary:
            background: '#2f302f'
        cursor:
          style:
            shape:
              Beam
        font:
          size: 8.0
      '';

      # ".config/nvim/colors/customgray.vim" = {
      #   source = ./../programs/vim/customgray.vim;
      # };

    
      ".config/i3" = {
       source = ./../programs/i3;
       recursive = true; 
      };

      ".config/dunst" = {
        source = ./../programs/dunst; 
       recursive = true; 
      };
    };

    sessionVariables = {};
  };

  programs = {
    #thunderbird = {
    #  enable = true;
    #  profiles."reinoud" = {
    #    isDefault = true;
    #    userChrome = ''
    #      #messengerWindow {
    #        background-color: #2f302f !important;
    #      }

    #    '';
    #  };
    #};
    git = {
      enable = true;
      userName = "GrannyCadet";
      userEmail = "s141959@ap.be ";
    };
    firefox = {
      enable = true;
      profiles.reinoud = {
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          keepassxc-browser
        ];

        bookmarks = [
          {
            name = "pastebin";
            url = "pastebin.com";
          }
          {
            name = "snb project";
            url = "http://10.152.4.93";
          }
          {
            name = "nix sites";
            # toolbar = true;
            bookmarks = [
              {
                name = "mipmip home-manager search";
                url = "https://mipmip.github.io/home-manager-option-search/";
              }
              {
                name = "jellyfin_public";
                tags = [ "jellyfin" "public" ];
                keyword = "jellyfin";
                url = "http://perfectekindje.airdns.org:59419";
              }
              {
                name = "nixos wiki";
                url = "https://nixos.wiki";
              }
            
            ];
          }
          {
            name = "server";
            # toolbar = true;
            bookmarks = [
              {
                name = "airvpn";
                tags = [ "vpn" "server" ];
                keyword = "vpn";
                url = "https://airvpn.org";
              }
              {
                name = "jellyfin_private";
                tags = [ "jellyfin" "private" ];
                keyword = "jellyfin";
                url = "http://192.168.0.125:59419";
              }

            ];
          }
          {
            name = "lemmy";
            url = "lemmy.world";
          }
          {
            name = "github";
            url = "https://github.com";
          }
          {
            name = "drankenkas";
            tags = [ "ksa" "dk" ];
            keyword = "ksa";
            url = "https://ksa-drankenkas.web.app";
          }
          {
            name = "open-subtitles";
            tags = [ "torrenting" "jellyfin" "subtitles" ];
            keyword = "subtitles";
            url = "https://opensubtitles.org";
          }
          {
            name = "iptorrents";
            tags = [ "iptorrents" "torrenting" ];
            keyword = "torrenting";
            url = "https://iptorrents.me";
          }
          {
            name = "1337x.to";
            tags = [ "torrenting" ];
            keyword = "torrenting"; 
            url = "https://1337x.to";
          }
          {
            name = "fearnopeer";
            tags = [ "torrenting" ];
            keyword = "torrenting";
            url = "https://fearnopeer.com";
          }
          {
            name = "chatgpt";
            tags = ["chatgpt" "ai"];
            keyword = "chatgpt";
            url = "https://chat.openai.com";
          }
          {
            name = "learning";
            tags = ["ap"];
            keyword = "ap";
            url = "https://learning.ap.be";
          }
          {
            name = "student";
            tags = ["ap"];
            keyword = "ap";
            url = "https://student.ap.be";
          }
          {
            name = "teams";
            tags = ["teams" "ap"];
            keyword = "teams";
            url = "https://teams.microsoft.com/";
          }
          {
            name = "google drive";
            tags = ["drive"];
            keyword = "drive";
            url = "https://drive.google.com";
          } 

        ];

        search = {
          force = true;
          default = "DuckDuckGo";
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php";
                params = [ { name = "search"; value = "{searchTerms}"; }];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };

          };
        };

        userContent = ''
/* 
┌─┐┬┌┬┐┌─┐┬  ┌─┐
└─┐││││├─┘│  ├┤ 
└─┘┴┴ ┴┴  ┴─┘└─┘
┌─┐┌─┐─┐ ┬      
├┤ │ │┌┴┬┘      
└  └─┘┴ └─

by Miguel Avila

*/

:root {
  scrollbar-width: none !important;
}

@-moz-document url(about:privatebrowsing) {
  :root {
    scrollbar-width: none !important;
  }
}
        '';
        userChrome = ''



/* Hide the 'List All Tabs' button */
#alltabs-button {
    display: none !important;
}

#reload-button {
    display: none !important;
}

/* Hide the bookmarks bar */
#PersonalToolbar { 
  display: none !important; 
}



        /*
┌─┐┬┌┬┐┌─┐┬  ┌─┐
└─┐││││├─┘│  ├┤
└─┘┴┴ ┴┴  ┴─┘└─┘
┌─┐┌─┐─┐ ┬
├┤ │ │┌┴┬┘
└  └─┘┴ └─

by Miguel Avila

*/

/*

┌─┐┌─┐┌┐┌┌─┐┬┌─┐┬ ┬┬─┐┌─┐┌┬┐┬┌─┐┌┐┌
│  │ ││││├┤ ││ ┬│ │├┬┘├─┤ │ ││ ││││
└─┘└─┘┘└┘└  ┴└─┘└─┘┴└─┴ ┴ ┴ ┴└─┘┘└┘

*/

:root {
  --sfwindow: #2f302f;
  --sfsecondary: #2f302f;
}

/* Urlbar View */

/*─────────────────────────────*/
/* Comment this section if you */
/* want to show the URL Bar    */
/*─────────────────────────────*/

.urlbarView {
  display: none !important;
}



/*─────────────────────────────*/

/*
┌─┐┌─┐┬  ┌─┐┬─┐┌─┐
│  │ ││  │ │├┬┘└─┐
└─┘└─┘┴─┘└─┘┴└─└─┘
*/

/* Tabs colors  */
#tabbrowser-tabs:not([movingtab])
  > #tabbrowser-arrowscrollbox
  > .tabbrowser-tab
  > .tab-stack
  > .tab-background[multiselected='true'],
#tabbrowser-tabs:not([movingtab])
  > #tabbrowser-arrowscrollbox
  > .tabbrowser-tab
  > .tab-stack
  > .tab-background[selected='true'] {
  background-image: none !important;
  background-color: var(--toolbar-bgcolor) !important;
}

/* Inactive tabs color */
#navigator-toolbox {
  background-color: var(--sfwindow) !important;
}

/* Window colors  */
:root {
  --toolbar-bgcolor: var(--sfsecondary) !important;
  --tabs-border-color: var(--sfsecondary) !important;
  --lwt-sidebar-background-color: var(--sfwindow) !important;
  --lwt-toolbar-field-focus: var(--sfsecondary) !important;
}

/* Sidebar color  */
#sidebar-box,
.sidebar-placesTree {
  background-color: var(--sfwindow) !important;
}

/*

┌┬┐┌─┐┬  ┌─┐┌┬┐┌─┐
 ││├┤ │  ├┤  │ ├┤
─┴┘└─┘┴─┘└─┘ ┴ └─┘
┌─┐┌─┐┌┬┐┌─┐┌─┐┌┐┌┌─┐┌┐┌┌┬┐┌─┐
│  │ ││││├─┘│ ││││├┤ │││ │ └─┐
└─┘└─┘┴ ┴┴  └─┘┘└┘└─┘┘└┘ ┴ └─┘

*/

/* Tabs elements  */
.tab-close-button {
  display: none;
}

.tabbrowser-tab:not([pinned]) .tab-icon-image {
  display: none !important;
}

#nav-bar:not([tabs-hidden='true']) {
  box-shadow: none;
}

#tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])
  > #tabbrowser-arrowscrollbox
  > .tabbrowser-tab[first-visible-unpinned-tab] {
  margin-inline-start: 0 !important;
}

:root {
  --toolbarbutton-border-radius: 0 !important;
  --tab-border-radius: 0 !important;
  --tab-block-margin: 0 !important;
}

.tab-background {
  border-right: 0px solid rgba(0, 0, 0, 0) !important;
  margin-left: -4px !important;
}

.tabbrowser-tab:is([visuallyselected='true'], [multiselected])
  > .tab-stack
  > .tab-background {
  box-shadow: none !important;
}

.tabbrowser-tab[last-visible-tab='true'] {
  padding-inline-end: 0 !important;
}

#tabs-newtab-button {
  padding-left: 0 !important;
}

/* Url Bar  */
#urlbar-input-container {
  background-color: var(--sfsecondary) !important;
  border: 1px solid rgba(0, 0, 0, 0) !important;
}

#urlbar-container {
  margin-left: 0 !important;
}

#urlbar[focused='true'] > #urlbar-background {
  box-shadow: none !important;
}

#navigator-toolbox {
  border: none !important;
}

/* Bookmarks bar  */
.bookmark-item .toolbarbutton-icon {
  display: none;
}
toolbarbutton.bookmark-item:not(.subviewbutton) {
  min-width: 1.6em;
}

/* Toolbar  */
#tracking-protection-icon-container,
#urlbar-zoom-button,
#star-button-box,
#pageActionButton,
#pageActionSeparator,
#tabs-newtab-button,
#back-button,
#PanelUI-button,
#forward-button,
.tab-secondary-label {
  display: none !important;
}

.urlbarView-url {
  color: #dedede !important;
}

/* Disable elements  */
#context-navigation,
#context-savepage,
#context-pocket,
#context-sendpagetodevice,
#context-selectall,
#context-viewsource,
#context-inspect-a11y,
#context-sendlinktodevice,
#context-openlinkinusercontext-menu,
#context-bookmarklink,
#context-savelink,
#context-savelinktopocket,
#context-sendlinktodevice,
#context-searchselect,
#context-sendimage,
#context-print-selection {
  display: none !important;
}

#context_bookmarkTab,
#context_moveTabOptions,
#context_sendTabToDevice,
#context_reopenInContainer,
#context_selectAllTabs,
#context_closeTabOptions {
  display: none !important;
}
        '';

        #userContent = ''
        #  /* Set the background color for the home screen */
        #  @-moz-document url("about:home"), url("about:newtab") {
        #    body {
        #      background-color: #2f302f !important;
        #    }
        #  }

        #  .footer, .ad-banner { display: none !important; }

        #  body {
        #    background-color: #2f302f !important;
        #    color: #ffffff !important; /* Adjust text color for readability */
        #  }
        #'';

        #userChrome = ''   
        #/* removes the show all tabs button /*
##alltabs-button {
    #display: none !important;
#}



#:root:not([customizing]) #nav-bar {
    #min-height: 2.5em !important;
    #height: 2.5em !important;
    #margin: 0 0 -2.5em !important;
    #z-index: -1000 !important;
    #opacity: 0 !important;
#}

#:root:not([customizing]) #nav-bar:focus-within {
    #z-index: 1000 !important;
    #opacity: 1 !important;
#}



        #/* removed "import bookmarks" /*
##PersonalToolbar #import-button {
  #display: none !important;
#}




##context_bookmarkTab,
##context_moveTabOptions,
##context_sendTabToDevice,
##context_reopenInContainer,
##context_selectAllTabs,
##context_closeTabOptions {
  #display: none !important;
#}

#/* Disable elements  */
##context-navigation,
##context-savepage,
##context-pocket,
##context-sendpagetodevice,
##context-selectall,
##context-viewsource,
##context-inspect-a11y,
##context-sendlinktodevice,
##context-openlinkinusercontext-menu,
##context-bookmarklink,
##context-savelink,
##context-savelinktopocket,
##context-sendlinktodevice,
##context-searchselect,
##context-sendimage,
##context-print-selection {
  #display: none !important;
#}



#/* Toolbar  */
##tracking-protection-icon-container,
##urlbar-zoom-button,
##star-button-box,
##pageActionButton,
##pageActionSeparator,
##tabs-newtab-button,
##back-button,
##PanelUI-button,
##forward-button,
#.tab-secondary-label {
  #display: none !important;
#}

##tabs-newtab-button {
  #padding-left: 0 !important;
#}

#:root {
  #--toolbarbutton-border-radius: 0 !important;
  #--tab-border-radius: 0 !important;
  #--tab-block-margin: 0 !important;
#}


        #  .urlbarView {
        #    display: none !important;
        #  }

        #  /* remove list all tabs
        #  #alltabs-button {
        #    display: none !important;
        #  }

        #  /* remove new tab
        #  #new-tab-button, #tabs-newtab-button {
        #    display: none !important;
        #  }

        
        #  /* Shorten the URL search bar */
        #  /*#urlbar-container {
        #  /*  max-width: 400px !important; /* Adjust the width as needed */
        #  /*}

        #  /* Hide shortcuts on the Firefox homepage */
        #  @-moz-document url("about:home"), url("about:newtab") {
        #    .top-sites {
        #      display: none !important;
        #    }
        #  }

        #  #reload-button { 
        #    display: none !important; 
        #  }

          
        #  scrollbar { display: none !important; }

        #  .tabbrowser-tab { min-width: 60px !important; }

        #  /* #back-button, #forward-button { display: none !important; }

        #  #tabbrowser-tabs[style^="max-height:"][style*="px"] { 
        #   visibility: collapse !important; 
        #  }

          
        #  /* hide bookmarks except new TabsToolbar
        #  #PersonalToolbar:not([customizing]){
        #   visibility: collapse !important;
        #  }
        #  #main-window[title^="New Tab"] #PersonalToolbar{
        #   visibility: visible !important;
        #  }


        #  /* Set the background color for various UI elements */
        #  #nav-bar, /* Navigation bar */
        #  #toolbar-menubar, /* Menu bar */
        #  #TabsToolbar, /* Tab bar */
        #  #PersonalToolbar { /* Bookmarks bar */
        #    background-color: #2f302f !important;
        #  }

        #  /* Style the tab background */
        #  .tab-background {
        #    background-color: #2f302f !important;
        #  }

        #  /* Style the main menu */
        #  #appMenu-popup {
        #    background-color: #2f302f !important;
        #  }

        #  /* You can continue adding other UI elements here */
        #'';

        settings = {

          "layers.acceleration.force-enabled" = true;
          "gfx.webrender.all" = true;
          "svg.context-properties.content.enabled" = true;

          "privacy.trackingprotection.enabled" = true;
          "browser.contentblocking.category" = "strict"; # Change to 'standard', 'strict', or 'custom'
          "privacy.fingerprintProtection" = true;
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.cookies" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.sessions" = true;
          "privacy.clearOnShutdown.siteSettings" = false;  # Keep site-specific preferences

          "ui.systemUsesDarkTheme" = 1;
          "identity.fxaccounts.enabled" = false;
          "browser.aboutConfig.showWarning" = false;
          "browser.aboutwelcome.enabled" = false;
          "dom.security.https_only_mode" = true;

          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.download.autohideButton" = true;
          "browser.download.clearHistoryOnDelete" = true;
          "browser.safebrowsing.downloads.remote.block_dangerous" = true;
          "browser.download.panel.shown" = true;
          "browser.search.suggest.enabled" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage" = "localhost";
          "browser.startup.page" = 1; # Restore previous session
          "browser.tabs.warnOnClose" = false;
          "browser.warnOnQuit" = false;
          "browser.download.useDownloadDir" = false;

          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "devtools.selfxss.count" = 5; # Allow pasting into console
          "services.sync.engine.creditcards" = false;
          "services.sync.engine.passwords" = false;
          "services.sync.engine.prefs" = false;
          "services.sync.username" = "kira.bruneau@pm.me";
          "signon.rememberSignons" = false; # Use keepassxc instead

          "toolkit.telemetry.pioneer-new-studies-available" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };

    lf = {
      enable = true;
      settings = {
        preview = true;
        drawbox = true;
        icons = true;
        ignorecase = true; 
      };
      keybindings = {
        "<enter>" = "open";
        V = ''$${pkgs.bat}/bin/bat "$f"'';
        "." = "set hidden!";
        c = "mkdir";
        a = ''$$EDITOR'';
      };
      commands = {
        dragon-out = ''${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
        editor-open = ''$$EDITOR $f'';
        e = ''$$EDITOR $f'';
        sh = ''$echo $(pwd) > /tmp/.screenshotpath'';
        mkdir = ''
         ''${{
            printf "Directory Name: " 
            read DIR
            mkdir $DIR
          }}
        '';
        extract = ''
          ''${{
            set -f
            case $f in
            *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
            *.tar.gz|*.tgz) tar xzvf $f;;
            *.tar.xz|*.txz) tar xJvf $f;;
            *.zip) unzip $f;;
            *.rar) unrar x $f;;
            *.7z) 7z x $f;;
            esac
          }}
        '';
        tar = ''
          ''${{
          set -f
          mkdir $1
          cp -r $fx $1
          tar czf $1.tar.gz $1
          rm -rf $1
        }}'';
        zip = ''
          ''${{
          set -f
          mkdir $1
          cp -r $fx $1
          zip -r $1.zip $1
          rm -rf $1
        }}'';
      }; 

      extraConfig = ''
        &${pkgs.ctpv}/bin/ctpv -s $id
        cmd on-quit %${pkgs.ctpv}/bin/ctpv -e $id
        set cleaner ${pkgs.ctpv}/bin/ctpvclear
          '';
    }; # sluit lf
    home-manager.enable = true;
  }; # sluit programs af
  
  services = {
    dunst = {
      enable = true;
    }; 
  };

  nixpkgs.config = {
    packageOverrides = pkgs: rec{
      dmenu = pkgs.dmenu.override {
        patches = [
          ./../programs/dmenu/insencitive.diff 
          ./../programs/dmenu/height.diff 
        ]; 
      }; 
    }; 
  };
}; # sluit home af
}
