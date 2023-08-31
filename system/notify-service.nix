{ pkgs ? import <nixpkgs> {} }:

let
  libnotify = pkgs.libnotify;
in

pkgs.stdenv.mkDerivation {
  name = "notify-service";
  buildInputs = [ libnotify ];
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/bin
    echo '#!/bin/sh' >> $out/bin/notify-service
    echo '$libnotify/bin/notify-send "Test" "This is a test notification."' >> $out/bin/notify-service
    chmod +x $out/bin/notify-service
  '';
}

