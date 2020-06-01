{ config, lib, pkgs, ... }:
with lib;
{
  config.programs.adb.enable = true;
  config.environment.systemPackages = with pkgs; [
    adb-sync
    androidStudioPackages.dev
    apktool
  ];
}
