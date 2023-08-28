#!/bin/sh 
pushd ~/.dotfiles/
nix build .#homeManagerConfigurations.reinoud.activationPackage
./result/activate
popd

