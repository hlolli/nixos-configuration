{ config, lib, pkgs, ... }:

with lib;
{
  config.environment.systemPackages = with pkgs; [
    (yarn.override ({ nodejs = pkgs.nodejs14; }))
    nodejs14
  ];
}
