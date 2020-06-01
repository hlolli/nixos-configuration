{ config, lib, pkgs, ... }:

{
    config.environment.systemPackages = with pkgs; [
      keen4
      steam
      wine
      winetricks
      xboxdrv
      zsnes
    ];
}
