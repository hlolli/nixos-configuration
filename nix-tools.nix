{ config, lib, pkgs, ... }:
with lib;
let
  nix-prefetch-github = import (pkgs.fetchFromGitHub {
    owner = "seppeljordan";
    repo = "nix-prefetch-github";
    rev = "638d8b062d4549927ca";
    sha256 = "01c98cgs2gxlcw7pbx7r0i4k20la9ax8i243l2kxmz9102mn9g1y";
  }
  );
in
{
  config = {
    environment.systemPackages =
      with pkgs; [
        nix-prefetch-github
        nix-prefetch-scripts
        nixops
        nixpkgs-review
      ];
  };
}
