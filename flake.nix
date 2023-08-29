{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";


    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, home-manager, nixpkgs-unstablen, ...}@inputs: 
  let
    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    
  in {
    homeManagerConfigurations = {
      reinoud = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./users/reinoud/home.nix 
          # {
          #   home = {
          #     username = "reinoud";
          #     homeDirectory = "/home/reinoud";
          #    stateVersion = "23.05"; 
          #   }; 
          # }
        ];
      }; 
    }; 


    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
        modules = [
          ./system/configuration.nix
        ]; 
      }; 
    }; 
  };
}
