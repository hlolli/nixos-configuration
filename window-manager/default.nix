{ config, lib, pkgs, ... }:
with lib;
{
  config.services.xserver.windowManager.i3 = {
    enable = true;
    configFile = "${import ./i3config.nix { inherit pkgs; }}/share/i3config";
    extraPackages = with pkgs; [
      dmenu
      i3status-rust
      i3lock
      i3blocks
    ];
  };
  config.environment.systemPackages = with pkgs; [
    rofi.out
  ];
}
