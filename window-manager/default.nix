{ config, lib, pkgs, ... }:

let
    # sway-contrib-p =  pkgs.callPackage sway-contribNix {};
    waybar = (pkgs.waybar.override {
      traySupport = true;
      pulseSupport = true;
      nlSupport = true;
      udevSupport = true;
      swaySupport = true;
      mpdSupport = true;
      withMediaPlayer = true;
    }).overrideAttrs(oldAttrs: {
      postInstall = "rm -rf $out/etc";
    });

in with lib; {

  config = {
    programs.xwayland.enable = true;
    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [
        conky
        swaylock # lockscreen
        swayidle
        sway-contrib.grimshot
        # waybar # status bar
        # mako # notification daemon
        kanshi # autorandr
        rofi # dmenu
        grim # screenshots
        # wl-clipboard # Wayland clipboard utilities
        clipman
        pipewire
      ];
    };

    xdg.portal.enable = true;
    xdg.portal.gtkUsePortal = true;
    xdg.portal.extraPortals = with pkgs;
      [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    services.dbus.packages = with pkgs;
      [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];

    environment = {
      etc = {
        "sway/config".source = "${import ./swayconfig.nix { inherit pkgs; }}/share/swayconfig";
        "xdg/waybar/config".text = builtins.toJSON {
          position = "bottom";
          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-center = [ "sway/window" ];
          modules-right = [
            "idle_inhibitor"
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "temperature"
            "backlight"
            "battery"
            "clock"
            "tray"
          ];
          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{name}: {icon}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
            };
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          clock = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          cpu = {
            format = "{usage}% CPU";
            tooltip = false;
          };
          memory = {
            format = "{}% M";
          };
          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}°C";
            # format-icons = ["" "" ""];
          };
          backlight = {
            format = "{percent}% {icon}";
            format-icons = ["" ""];
          };
          battery = {
            states = {
              good= 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            # "format-good": ""; // An empty format will hide the module
            # "format-full": "",
            format-icons = ["" "" "" "" ""];
          };
          network = {
            # "interface": "wlp2*"
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          pulseaudio = {
            # "scroll-step": 1, // %, can be a float
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
          };
        };
        "xdg/waybar/style.css".source = ./waybar/style.css;
      };
      variables = {
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_USE_XINPUT2 = "1";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "sway";
        # WAYLAND_DISPLAY = "wayland-0";
        # DISPLAY = ":0.0";
      };
    };

    # exec {pkgs.networkmanagerapplet}/bin/nm-applet --indicator &>/dev/null & disown;
    # exec {pkgs.numlockx}/bin/numlockx on &>/dev/null & disown;
    # exec {pkgs.alsaUtils}/bin/alsactl init &>/dev/null & disown;

    environment.systemPackages = [
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
      environment = {
        PATH = lib.mkForce null;
        XKB_DEFAULT_LAYOUT = "is";
        QT_QPA_PLATFORM = "wayland";
        XDG_SESSION_TYPE = "wayland";
        XDG_RUNTIME_DIR = "/run/user/1000";
        SWAYSOCK = "/var/tmp/sway.sock";
      };
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

    systemd.user.services.kanshi = {
      description = "Kanshi output autoconfig ";
      wantedBy = [ "sway-session.target" ];
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

    systemd.user.services.waybar = {
      description = "Waybar as systemd service";
      environment = {
        # DISPLAY = ":0";
        # XDG_CURRENT_DESKTOP = "Unity";
        # QT_QPA_PLATFORM = "wayland";
        # XDG_SESSION_TYPE = "wayland";
        # XDG_RUNTIME_DIR = "/run/user/1000";
        # SWAYSOCK = "/var/tmp/sway.sock";
      };
      path = waybar.buildInputs ++ [
        pkgs.libappindicator-gtk3
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
        pkgs.dbus
        pkgs.fira-mono
        pkgs.font-awesome
        pkgs.pavucontrol
        pkgs.sway
      ];
      wantedBy = [ "sway-session.target" ];
      script = "${pkgs.dbus}/bin/dbus-run-session -- ${waybar}/bin/waybar -c /etc/xdg/waybar/config -s /etc/xdg/waybar/style.css";
    };
  };
}
