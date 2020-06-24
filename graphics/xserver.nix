{ config, lib, pkgs, ... }:
with lib;
let
  nvidia = pkgs.linuxPackages.nvidia_x11;
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
    services.xserver = {
      enable = true;
      layout = "is";
      exportConfiguration = true;
      xkbOptions = "eurosign:e";
      synaptics.enable = true;
      synaptics.twoFingerScroll = true;
      synaptics.tapButtons = false;
      synaptics.accelFactor = "0.1";
      synaptics.fingersMap = [ 1 3 2 ];
      # xrandrHeads = [ "HDMI-0" "eDP1" ];
      videoDrivers = [ "nvidia" "modesetting" ];

      deviceSection = ''
        VendorName     "onboard"
        Driver         "modesetting"
        Option         "AccelMethod" "sna"
        BusID   "PCI:0:2:0"
      '';
      screenSection = ''
        Monitor        "eDP-0"
      '';
      serverLayoutSection = ''
        Screen "Screen-modesetting[0]"
      '';
      moduleSection = ''
        Load "glx"
        Load "modesetting"
      '';
      serverFlagsSection = ''
        Option "Xinerama" "0"
      '';

    };

    services.xserver.config = builtins.readFile ./nvidia.txt;

    services.redshift = {
      enable = true;
    };

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
      glxinfo
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
      gparted
      hexchat
      keepassx-community
      libGL
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
      # unity3dFork
      # unityhub
      vdpauinfo
      vlc
      xclip
      xkeyboard_config
      xlibs.xmodmap
      xorg.libX11
      xorg.libxcb
      xorg.xmodmap
      xorg.xev
      xorg.xkill
      xorg.xf86videointel
      xorg.xwininfo
      xorg.xbacklight
      xorg.xhost
      xorg.xrandr
      xsaneGimp
      xsel
    ];
  };
}
