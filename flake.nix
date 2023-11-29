{
  description = "A very basic flake";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true; 
        };
      };

      lib = nixpkgs.lib;

    in {

      homeManagerConfigurations = {
        system = "x86_64-linux";
        modules = [
          ./users/reinoud/home.nix 
          {
            home = {
              username = "reinoud";
              homeDirectory = "/home/reinoud";
              stateVersion = "23.05";
            };
          }
        ];
      }; 
      
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./system/configuration.nix 
            ./system/newpkgs.nix
          ]; 
        }; 
      }; 
    };
}
