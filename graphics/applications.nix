{ config, lib, pkgs, ... }:
with lib;
let
  moz_overlay = import (pkgs.fetchFromGitHub
    { owner = "mozilla";
      repo = "nixpkgs-mozilla";
      rev = "57c8084c7ef41366993909c20491e359bbb90f54";
      sha256 = "0lchhjys1jj8fdiisd2718sqd63ys7jrj6hq6iq9l1gxj3mz2w81";
    });
  mozpkgs = import <nixpkgs> {
    overlays = [ moz_overlay ];
    config = {
      allowUnfree = true;
    };
  };
  # chromium = pkgs.chromium.override { libva = pkgs.libva; enableVaapi = true; useOzone = true; };
  xsaneGimp = pkgs.xsane.override { gimpSupport = true; };
  obsPlugins = pkgs.runCommand "obs-studio-plugins" {
    preferLocalBuild = true;
    allowSubstitutes = false;
  } ''
    mkdir $out
    for plugin in ${concatStringsSep " " [pkgs.obs-v4l2sink]}; do
      ln -s "$plugin"/* $out/
    done
  '';

in with mozpkgs;
{
  config = {
   fonts.fonts = with pkgs;
      [ fira-mono fira dejavu_fonts ];
    environment.systemPackages = with pkgs; [
      ario
      asciinema
      # autocutsel
      bitwarden
      bitwarden-cli
      chromium
      elementary-xfce-icon-theme
      evince
      ffmpeg-full
      # firefox
      fontconfig.out
      gimp
      # glxinfo
      gnome3.gnome_control_center
      gnome3.eog
      gnome3.evolution
      gnome3.file-roller
      gnome3.gnome-font-viewer
      gnome3.mutter
      gnome3.networkmanagerapplet
      gnome3.gedit
      gnome3.gvfs
      gnome3.nautilus
      gnome3.gnome-user-share
      gnome3.dconf
      gnome3.gnome-session
      gnome3.gnome-system-monitor
      gnome3.gnome_terminal
      gparted
      hexchat
      keepassx-community
      # libGL
      libreoffice
      libva-full
      libvdpau-va-gl
      # meld
      latest.firefox-nightly-bin
      mypaint
      mpv
      # mpv-with-scripts
      networkmanager
      numlockx
      # owncloudclient
      obsPlugins
      obs-studio
      olive-editor
      picard
      plasma-workspace-wallpapers
      primus
      signal-desktop
      sxiv
      # skype
      tdesktop
      thunderbird
      tor
      vdpauinfo
      vlc
      xclip
      xsaneGimp
      xsel
      xorg.xkill
      zoom-us
    ];
  };
}
