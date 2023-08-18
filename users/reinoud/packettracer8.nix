{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> {};
in {
  environment.systemPackages = [ unstable.ciscoPacketTracer8 ];
}

