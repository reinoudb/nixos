#!/bin/sh 
pushd ~/.dotfiles/
home-manager switch -f ./users/reinoud/home.nix
popd

