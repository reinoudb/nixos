{ inputs, ... }:
let
  unstable = inputs.nixpkgs-unstable;
  stable = inputs.nixpkgs-stable;

  unstablepackage = with unstable; [
    ciscoPacketTracer8
    wineWowPackages.unstableFull
    dwarfs
    wine-staging
    fuse-overlayfs
    bubblewrap
  ];

  stablepackage = with stable; [
     # browser
      librewolf
      tor-browser-bundle-bin
      tor 
      torsocks
      brave
      firefox

      # social
      element-desktop
      russ
      iamb
      signal-desktop

      # txt editors
      vim-full
      kate

      # virtualization
      virt-manager
      vmware-workstation
      qemu_full

     # Gaming
     vitetris
     prismlauncher-unwrapped
     jdk17
      xwiimote
      wiiuse
      wiiload
      dolphin-emu

    # audio & video
    freetube
      blueman
      pulseaudioFull
      alsa-utils
      vlc
      pipe-viewer
      spotify
      spotifyd
      spotify-player
      youtube-tui
      gpicview
      feh
      xcolor
      gimp

    # core
    hstr # hh command 
    tpm-tools
    tree
    tpm2-tss
    iw
    jmtpfs # mtp for phones
    screen
    auto-cpufreq
    samba4Full
    btrfs-progs
    bridge-utils
    mpv
    blugon
    unrar-wrapper
    dig
    sshfs
    psmisc
    linuxKernel.packages.linux_zen.cpupower
    cargo
    tmux
    findutils
    gnome.zenity
    bash
    python3Full
    wireguard-tools
    wget
    zip
    unzip
    htop
    btop
    libnotify
    brightnessctl
    playerctl
    git
    cryptsetup
    polkit_gnome
    lsof
    dunst
    p7zip
    ntfs3g
    arandr
    android-udev-rules
    ncdu
    podman
    distrobox
    wirelesstools

# networking
      nmap
      wireshark
      rclone

# office
      lf
      thunderbird
      libreoffice
      onlyoffice-bin
      tutanota-desktop
      electron-mail
      wcalc
     pro-office-calculator 
     xfce.xfce4-screenshooter
     xfce.thunar
     dolphin 

# desktop
      lxappearance
      i3
      x11basic
      xdg-desktop-portal-gnome
      i3status
      lightdm
      i3blocks

# backup
      vorta
      borgbackup

# other
    alacritty
    qbittorrent
    filezilla
    fish
    neofetch
    gparted
    keepassxc
    rofi
    rofi-vpn
    rofi-calc
    rofi-power-menu


  ];
in
{
  nixosConfigurations = {
    my-config = {
      environment.systemPackages = stablepackage ++ unstablepackage; 
    }; 
  };
}
