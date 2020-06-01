{ config, lib, pkgs, ... }:
let
  global-python-packages = python-packages: with python-packages; [
    parameterized
    pyyaml
  ];
  python3 = pkgs.python38.withPackages global-python-packages;
in {
  config.environment.systemPackages = with pkgs; [
    conda
    pipenv
    python3
  ];
}
