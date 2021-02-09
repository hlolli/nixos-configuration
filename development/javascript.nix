{ config, lib, pkgs, ... }:

with lib;
{
  config.environment.systemPackages = with pkgs; [
    (yarn.override { nodejs = nodejs-15_x; })
    nodejs-15_x
  ];
}
