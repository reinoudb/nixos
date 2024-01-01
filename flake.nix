{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true; 
        };
      };

      lib = nixpkgs.lib;

    in {

      # homeManagerConfigurations = {
      #   extraSpecialArgs = { inherit inputs; };
      #   system = "x86_64-linux";
      #   modules = [
      #     ./users/reinoud/home.nix 
      #     {
      #       home = {
      #       };
      #     }
      #   ];
      # }; 
      
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          inherit system;
          modules = [
            # nur.nixosModules.nur
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            (import (./system/configuration.nix))
          ];
        }; 
      }; 
    };
}
