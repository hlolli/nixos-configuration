{ config, lib, pkgs, ... }:
with lib;
  {
    config.environment.systemPackages = with pkgs;
      [
        bluezFull
        blueman
      ];
  }
