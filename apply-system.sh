#!/bin/sh 
pushd ~/.dotfiles/ 
sudo nixos-rebuild switch --flake .# && notify-send "Rebuild Done!"
# sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd
