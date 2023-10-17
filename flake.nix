{
  description = "Hlöðver's something...";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixos-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixos-unstable, nix-darwin, flake-compat, flake-utils, deploy-rs }:
    let

      inherit (pkgs) stdenv lib;
      overlays = [ ];

      pkgs = (import nixpkgs {
        inherit overlays;
        system = "aarch64-darwin";
        config = {
          allowUnfree = true;
        };
      });

      pkgs-nixos-unstable = import nixos-unstable {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };

      darwinConfigurations = nix-darwin.lib.darwinSystem
        {
          modules = [ ./darwin ];
          specialArgs = { inherit inputs; };
        };
    in
    ({
      nixpkgs.config.allowUnfree = true;

      darwinConfigurations = {
        hlodvers-mbp = darwinConfigurations;
        Hlodvers-Air = darwinConfigurations;
        Hlodvers-MacBook-Pro = darwinConfigurations;
        # Hlodvers-Air.fritz.box = darwinConfigurations;
        Hlodvers-MacBook-Air = darwinConfigurations;
      };

      nixosConfigurations = {
        hlolli-cloud = nixos-unstable.lib.nixosSystem {
          pkgs = pkgs-nixos-unstable;
          system = "x86_64-linux";
          modules = [ ./hlolli-cloud/configuration.nix ];
        };
      };

      deploy.nodes = {
        hlolli-cloud = {
          hostname = "95.216.170.8";
          profiles.system = {
            user = "root";
            sshUser = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hlolli-cloud;
          };
        };
      };

    });
}
