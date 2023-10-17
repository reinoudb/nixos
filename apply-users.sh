#!/bin/sh 
pushd ~/.dotfiles/
# home-manager switch -f ./users/reinoud/home.nix
home-manager switch --file ./users/reinoud/
popd

