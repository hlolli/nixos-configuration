{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ podman docker ];
}
