#!/bin/sh
# script for activating / choosing wireguard vpn

pushd ~/.dotfiles/secrets/wireguard/ > /dev/null

vpn_connect () {
  alacritty -e sudo wg-quick $1 ~/.dotfiles/secrets/wireguard/$2.conf
  new=0
}

vpn_new () {
  choices="$conf\ncancel"
  keuze=$(echo -e "$choices" | dmenu -i -p "What server")
  if [[ $keuze = "cancel" ]]; then
    exit
  else
    vpn_connect "up" $keuze
  fi
}

new=1

conf=$(ls *.conf | awk -F'.' '{print $1}')

interfaces=$(ls /proc/sys/net/ipv4/conf/)

# kijken of er al een vpn active is
for i in $interfaces ;
do 
  for x in $conf;
  do
    if [[ $x = $i ]]; then
      choices="ok\ndisconnect\nchange"
      keuze=$(echo -e "$choices" | dmenu -i -p "$x is already active" )
      case "$keuze" in
        ok) exit;;
        disconnect) vpn_connect "down" $x;;
        change) vpn_connect "down" $x
                new=1 
          ;;
      esac
    fi
  done   
done

if [[ $new = 1 ]]; then
  vpn_new
fi

popd > /dev/null
