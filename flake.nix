{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
    
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ...}@inputs: 

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
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;

    in {
      homeManagerConfigurations = {
        reinoud = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs; };
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./users/reinoud/home.nix 
          ];
        }; 
      }; 


      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ({config, pkgs, ...}: { nixpkgs.overlays = [ overlay-unstable ];})
            ./system/configuration.nix
          ]; 
        }; 
      }; 
    };
}
