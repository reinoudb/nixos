with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "freetube 0.19";
  src = fetchurl {
    url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v0.19.0-beta/freetube-0.19.0-linux-portable-x64.7z";
    sha256 = "sha256-ZCLAnj16svH/AMPuI8hAiPnma3AZMFoersrw5+278l4=";
  };
}
