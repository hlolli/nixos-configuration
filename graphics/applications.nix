{ config, lib, pkgs, ... }:
with lib;
let
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

in
{
  config = {
   # services.xserver = {
   #   enable = true;
   #   layout = "is";
   #   synaptics.enable = true;
   #   synaptics.twoFingerScroll = true;
   #   synaptics.tapButtons = false;
   #   synaptics.accelFactor = "0.1";
   #   synaptics.fingersMap = [ 1 3 2 ];
   # };
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
      firefox
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
      mypaint
      mpv
      # mpv-with-scripts
      networkmanager
      numlockx
      # owncloudclient
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
    ];
  };
}
