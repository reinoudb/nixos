{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  environment.systemPackages = with pkgs; [
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
  neovim

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


  unstable.wineWowPackages.unstableFull
  
    unstable.dwarfs
  unstable.wine-staging
  unstable.fuse-overlayfs
  unstable.bubblewrap
  # # unstable.gst-libav
  # unstable.gst-plugins-bad1
  # unstable.gst-plugins-base1
  # unstable.gst-plugins-good1
  # unstable.gst-plugins-ugly1
  # unstable.gstreamer-vaapi

  # vulkan-tools
  # vulkan-loader
  # steam-run
  # protontricks
  # protonup-qt
  # winetricks
  # steam 
  # lutris
  # perl536Packages.OpenGL
  # wineWowPackages.full
  # wineWowPackages.unstableFull
  # unstable.dwarfs
  # unstable.wine-staging
  # unstable.fuse-overlayfs

# audio & video
freetube
  blueman
  pulseaudioFull
  alsa-utils
  vlc
    # unstable.freetube
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
  unstable.ciscoPacketTracer8
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
}
