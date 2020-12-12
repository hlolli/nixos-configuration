{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    environment.systemPackages = with pkgs;
      [
        libjack2.out
        meterbridge
        jack2.out
        jack_capture
        jack_rack
        # jackmix
        jack_oscrolloscope
        jackmeter
        qjackctl
        (pkgs.callPackage ./ebumeter.nix {})
      ];
   };
}
