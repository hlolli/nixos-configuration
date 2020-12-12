{ config, pkgs, ... }:

with config;
# let customXML = pkgs.writeText "custom.xml" "";
# ''
#      <?xml>
#        <service-group>
#          <name replace-wildcards="no">Example Service</name>
#          <service protocol="ipv6">
#            <type>_reactdev._tcp</type>
#            <domain-name>local</domain-name>
#            <host-name>hlolli.local</host-name>
#            <port>8000</port>
#          </service>
#        </service-group>'';

{
  programs.dconf.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  services.lorri.enable = true;
  services.printing.drivers = with pkgs; [ samsung-unified-linux-driver ];
  services.printing.enable = true;
  services.resolved.enable = true;
  services.upower.enable = true;
  services.keybase.enable = true;

  imports = [
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
  systemd.services.avahi-daemon.preStart = ''
    mkdir -p /etc/avahi/services
  '';
}
