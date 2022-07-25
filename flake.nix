{
  description = "Hlöðver's something...";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    emacs-ng = {
      url = "github:hlolli/emacs-ng?rev=d3b0824a6be75087562099c2e41f6ae5839a3ec2";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };

  outputs = { self, nixpkgs, darwin, flake-compat, flake-utils, emacs-ng }:
    let
      # systems = [ "aarch64-darwin" "x86_64-linux" ];
    # in flake-utils.lib.eachSystem systems (system:
      # let
      inherit (pkgs) stdenv lib;
      system = "aarch64-darwin";
      overlays = [];
      pkgs = (import nixpkgs {
        inherit overlays;
        currentSystem = system;
          config = {
            allowUnfree = true;
          };
      });
      darwinConfigurations = (darwin.lib.evalConfig {
        inputs = { inherit emacs-ng nixpkgs system; darwin = self; };
        modules = [ darwin.darwinModules.flakeOverrides ./darwin ];
      } // { inherit nixpkgs; currentSystem = system; });
    in ({
      nixpkgs.config.allowUnfree = true;

      # } // lib.optionalAttrs stdenv.isDarwin
      darwinConfigurations = {
        hlodvers-mbp = darwinConfigurations;
        Hlodvers-Air = darwinConfigurations;
        Hlodvers-MacBook-Pro = darwinConfigurations;
        # Hlodvers-Air.fritz.box = darwinConfigurations;
        Hlodvers-MacBook-Air = darwinConfigurations;
      };

      packages = {
        emacs = (pkgs.callPackage ../emacs.nix {}).emacs;
        darwinConfigurations = {
          hlodvers-mbp = darwinConfigurations;
          Hlodvers-Air = darwinConfigurations;
          Hlodvers-MacBook-Pro = darwinConfigurations;
          # Hlodvers-Air.fritz.box = darwinConfigurations;
          Hlodvers-MacBook-Air = darwinConfigurations;
        };
      };
    });
}
