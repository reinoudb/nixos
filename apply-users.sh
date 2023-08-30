#!/bin/sh 
pushd ~/.dotfiles/
# nix build .#homeManagerConfigurations.reinoud.activationPackage
home-manager switch -f ./users/reinoud/home.nix

# ./result/activate
popd

