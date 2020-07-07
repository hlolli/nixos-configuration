{ config, lib, pkgs, ... }:

let glpaperNix = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/" +
            "221e5eba47110ef9a174e2c5caf66351609c16ba/pkgs/development/tools/glpaper/default.nix";
      sha256 = "0d1vr4yl2pwr0nzwa3piyp2i5g733bdvqf002gs5z9di4cyg04jx";
    };
    sway-contribNix = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/" +
            "1db748ef6aa41ec9777a9bf97963d3a4f38866c0/pkgs/applications/window-managers/sway/contrib.nix";
      sha256 = "1b8a6x7ggz4zbawj8amyf90pkk448y1hxp2f3drnwir1vxhcim4s";
    };

    sway-contrib-p =  pkgs.callPackage sway-contribNix {};
    glpaper = pkgs.callPackage glpaperNix {};

in with lib; {

  config = {
    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [
        swaylock # lockscreen
        swayidle
        sway-contrib-p.grimshot
        sway-contrib-p.inactive-windows-transparency
        xwayland # for legacy apps
        waybar # status bar
        mako # notification daemon
        kanshi # autorandr
        rofi # dmenu
        grim # screenshots
        wl-clipboard # Wayland clipboard utilities
      ];
    };
    xdg.portal.enable = true; # device request (webcam chrome)

    environment = {
      etc = {
        "sway/config".source = "${import ./swayconfig.nix { inherit pkgs; }}/share/swayconfig";
        # "xdg/waybar/config".source = ./dotfiles/waybar/config;
        # "xdg/waybar/style.css".source = ./dotfiles/waybar/style.css;
      };
    };

    environment.systemPackages = with pkgs; [
      glpaper
      (
        pkgs.writeTextFile {
          name = "startsway";
          destination = "/bin/startsway";
          executable = true;
          text = ''
            #! ${pkgs.bash}/bin/bash

            # first import environment variables from the login manager
            systemctl --user import-environment
            # then start the service
            exec systemctl --user start sway.service
          '';
        }
      )
    ];

    systemd.user.targets.sway-session = {
      description = "Sway compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    systemd.user.services.sway = {
      description = "Sway - Wayland window manager";
      documentation = [ "man:sway(5)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
      # We explicitly unset PATH here, as we want it to be set by
      # systemctl --user import-environment in startsway
      environment.PATH = lib.mkForce null;
      environment.XKB_DEFAULT_LAYOUT="is";
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
        '';
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    programs.waybar.enable = true;

    systemd.user.services.kanshi = {
      description = "Kanshi output autoconfig ";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        # kanshi doesn't have an option to specifiy config file yet, so it looks
        # at .config/kanshi/config
        ExecStart = ''
          ${pkgs.kanshi}/bin/kanshi
        '';
        RestartSec = 5;
        Restart = "always";
      };
    };
  };
}
