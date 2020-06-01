{ config, lib, pkgs, ... }:
with lib;
let
  nodejs = pkgs.nodejs-13_x;
  frescobaldi = pkgs.frescobaldi.override { lilypond = pkgs.lilypond-with-fonts; };
in
{
  config = {
    environment.systemPackages =
      with pkgs; [
        discord
        emacs
        font-awesome-ttf
        filezilla
        franz # <social-media (delete?)>
        frescobaldi
        galculator
        go
        google-chrome
        gv
        imagemagick
        ispell
        jq
        lilypond-with-fonts
        matterbridge # <social-media (delete?)>
        nodePackages.node2nix
        nodejs
        pandoc
        ruby
        shellcheck
        slack
        spotify
        supercollider
        texlive.combined.scheme-full
        xclip
        xcompmgr
        xdotool
        (yarn.override
          ({ inherit nodejs; })
        )
      ];
  };
}
