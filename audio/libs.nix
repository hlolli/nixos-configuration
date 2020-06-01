{ config, lib, pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
        libsndfile.out
        mpg123
        ofono
    ];
  };
}
