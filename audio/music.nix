{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    environment.systemPackages = with pkgs;
      [
        aeolus
        ardour
        audacity
        cadence
        drumgizmo
        faust2
        faust2csound
        faust2jack
        reaper
        qsynth
        zam-plugins
    ];
  };
}
