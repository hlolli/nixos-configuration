{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    environment.systemPackages = with pkgs;
      [
        alsaOss
        alsaPlugins
        alsaTools
        alsaUtils
        alsa-firmware
      ];
    };
}
