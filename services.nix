{ config, pkgs, ... }:

with config;
{
  programs.dconf.enable = true;
  services.upower.enable = true;
  services.lorri.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ samsung-unified-linux-driver ];
  imports = [
    # ./services/datomic-socks.nix
    # ./services/nfs.nix
    ./custom-services/compton.nix
  ];
  customServices.compton = {
    enable = false;
    fade = false;
    shadow = true;
    extraOptions = ''
      inactive-dim = 0.5;
      focus-exclude = [ "class_g = 'Rofi'" ];
      inactive-dim-exclude = [ "window_type = 'dmenu'" ];
      mark-ovredir-focused = false;
    '';
  };
}
