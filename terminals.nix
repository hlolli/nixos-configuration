{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    environment.systemPackages = with pkgs; [
      autossh
      gnome3.gnome_terminal
      termite
      tmate
      tmuxinator
      tmuxPlugins.yank
      xterm
    ];
  };
}
