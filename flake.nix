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
    slackpr.url = "github:hlolli/nixpkgs/slack-darwin-aarch64";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, darwin, flake-compat, slackpr, flake-utils }:
    let
      systems = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" ];
    in flake-utils.lib.eachSystem systems (system:
      let
        inherit (pkgs) stdenv lib;
        overlays = [];
        pkgs = (import nixpkgs {
          inherit overlays system;
          config = { allowUnfree = true; };
        });
        darwinConfigurations = (darwin.lib.evalConfig {
          inputs = { inherit nixpkgs slackpr; darwin = self; system = "aarch64-darwin"; };
          modules = [ darwin.darwinModules.flakeOverrides ./darwin ];
        } // { inherit nixpkgs; currentSystem = "aarch64-darwin"; });
      in ({
        nixpkgs.config.allowUnfree = true;

      } // lib.optionalAttrs stdenv.isDarwin {

        packages = {
          emacs = (pkgs.callPackage ../emacs.nix {}).emacs;
          darwinConfigurations = {
            Hlodvers-Air.fritz.box = darwinConfigurations;
            Hlodvers-MacBook-Air = darwinConfigurations;
          };
        };
      }));
}
