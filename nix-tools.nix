{ config, lib, pkgs, ... }:
with lib;
let
  nix-prefetch-github = import (pkgs.fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "89dbb8d3829bd03894ec1b947080ebde652f2268";
    sha256 = "0f6f6f4hj235clw57v70asx4vg1dpmblyzim5mx0b0n8ddbjp7jm";
  }
  );
in
{
  config = {
    environment.systemPackages =
      with pkgs; [
        # nix-prefetch-github
        # nix-prefetch-scripts
        # nixops
        nixpkgs-review
      ];
  };
}
