{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    environment.systemPackages = with pkgs; [
      autossh
      termite
      tmate
      tmuxinator
      tmuxPlugins.yank
      xterm
    ];
  };
}
