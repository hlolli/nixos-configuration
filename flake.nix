{
  description = "Hlöðver's something...";

  inputs = {
    nixpkgs.url = "github:hlolli/nixpkgs";
    nixUnstable.url = "github:nixos/nix";
    nixUnstable.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    slackpr.url = "github:hlolli/nixpkgs/slack-darwin-aarch64";
  };

  outputs = { self, nixUnstable, nixpkgs, darwin, flake-compat, slackpr }:
    let darwinBase = ./darwin;

    in {
      nixpkgs.config.allowUnfree = true;

      darwinConfigurations."Hlodvers-MacBook-Air" = darwin.lib.evalConfig {
        inputs = { inherit nixUnstable nixpkgs slackpr; darwin = self; system = "aarch64-darwin"; };
        modules = [ darwin.darwinModules.flakeOverrides darwinBase ];
      } // { inherit nixpkgs; currentSystem = "aarch64-darwin"; };

       # packages.aarch64-darwin.goku = self.darwinConfigurations."Hlodvers-MacBook-Air".system.config.goku;

    };
}
