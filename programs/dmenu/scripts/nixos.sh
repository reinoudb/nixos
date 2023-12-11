#!/bin/sh
# dmenu script to rebuild update rebuild custom path home manager etc for nixos

rebuild () {
  alacritty -e sudo nixos-rebuild $1 $2
}

choises="switch\ntest\nupgrade\ndry-activate"

keuze=$(echo -e $choises | dmenu -i -p "How to rebuild?")

case $keuze in
  switch) rebuild switch;;
  test) rebuild test;;
  upgrade) switch --upgrade;;
  dry-activate) switch --dry-activate;;
esac
