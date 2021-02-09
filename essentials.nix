{ config, lib, pkgs, ... }:
with lib;
let
  frescobaldi = pkgs.frescobaldi.override { lilypond = pkgs.lilypond-with-fonts; };
  slack = pkgs.slack.overrideAttrs(oldAttrs: rec {
    rpath = makeLibraryPath [ pkgs.pipewire ] + ":" + oldAttrs.rpath;
    postInstall = ''
      rm $out/bin/slack
      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_CURRENT_DESKTOP : Unity \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${pkgs.xdg_utils}/bin
    '';
  });
in
{
  config = {
    environment.systemPackages =
      with pkgs; [
        ripcord # a discord client
        emacs
        fd
        font-awesome-ttf
        filezilla
        franz # <social-media (delete?)>
        frescobaldi
        galculator
        gcalcli # google-calendar cli
        go
        (google-chrome-dev.overrideAttrs (oldAttrs: rec {
          rpath = makeLibraryPath [ pkgs.pipewire pkgs.xorg.libxshmfence ]
                  + ":" + oldAttrs.rpath;
        }))
        gv
        imagemagick
        ispell
        jq
        keybase
        lilypond
        ncdu
        nodePackages.node2nix
        pandoc
        ruby
        shellcheck
        slack
        steam
        steam-run-native
        spotify
        supercollider
        texlive.combined.scheme-full
        xclip
        xcompmgr
        xdotool
      ];
  };
}
