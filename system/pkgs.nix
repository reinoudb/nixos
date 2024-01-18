{ config, pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
# browser
  librewolf
  tor-browser-bundle-bin
  tor 
  torsocks
  brave

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

# inputs.nix-gaming.packages."x86_64-linux".wine-ge
# inputs.nix-gaming.packages."x86_64-linux".dxvk
# inputs.nix-gaming.packages."x86_64-linux".proton-ge


 vitetris
 # prismlauncher-unwrapped
 # jdk17
 #  xwiimote
 #  wiiuse
 #  wiiload
 #  dolphin-emu


 #  lutris

 #  unstable.wineWowPackages.unstableFull
  wineWow64Packages.base
  unstable.dwarfs
  unstable.bubblewrap
  unstable.fuse-overlayfs
  unstable.wine64
 #  unstable.wine-staging
 #  unstable.fuse-overlayfs
 #  unstable.bubblewrap
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
  spotify-tui
  youtube-tui
  gpicview
  feh
  xcolor
  gimp

# core
xclip
jq
kitty
yad
obs-studio
maim
slop
bat
wpa_supplicant_gui
hstr # hh command 
tpm-tools
tpm2-tools
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
wirelesstools
#lf previeuws
ctpv
  atool ffmpegthumbnailer ffmpeg colordiff gnupg elinks ueberzug glow poppler_utils  

# networking
openvpn
  unstable.ciscoPacketTracer8
  nmap
  wireshark
  rclone

# office
subtitleedit
asciidoctor
  asciidoc
  lf
  thunderbird
  libreoffice
  onlyoffice-bin
  tutanota-desktop
  electron-mail
  protonmail-bridge
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

# kangaroot
vagrant
k9s
kubeconform

python311Packages.pyautogui
  ];
}
