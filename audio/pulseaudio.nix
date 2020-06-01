{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };

    environment.systemPackages = with pkgs;
      [
        pavucontrol
        pa_applet
        pulseaudio-dlna
        libpulseaudio
      ];
  };
}
