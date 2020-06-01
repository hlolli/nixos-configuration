{ config, lib, pkgs, ... }:
with lib; {
  config = {
    users.defaultUserShell = pkgs.fish;
    environment.systemPackages = with pkgs; [
      direnv
      lorri
      zsh
    ];
    programs = {
      bash = {
        enableCompletion = true;
        enableLsColors = true;
      };
    };
  };
}
