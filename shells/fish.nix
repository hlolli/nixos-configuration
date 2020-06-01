{ config, lib, pkgs, ... }:
{
  config = {
    programs.fish = {
      enable = true;
      promptInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
    };
  };
}
