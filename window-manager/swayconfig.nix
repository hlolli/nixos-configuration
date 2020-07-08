{ pkgs }:
let
  wallpaper = pkgs.fetchurl {
    url = "https://wallpapersultra.net/wp-content/uploads/Beautiful-Wallpaper-Nature-Lake.jpg";
    sha256 = "19bk4wh8q9xizn8vx0hy9xrsn3kk85jy24ibck3h3pwbqpavapx6";
  };
  cfg = pkgs.writeTextFile {
    name = "swayconfig";
    destination = "/share/swayconfig";
    text = ''
      set $mod Mod4
      font pango:Fira Mono 17
      default_border pixel 0
      floating_modifier $mod

      # Disable scrolling window bar
      bindsym button4 nop
      bindsym button5 nop

      bindsym $mod+Return exec ${pkgs.gnome3.gnome-terminal}/bin/gnome-terminal
       # kill focused window
      bindsym $mod+Shift+q kill
      bindsym $mod+Tab exec ${pkgs.rofi}/bin/rofi -show window
      bindsym $mod+d exec ${pkgs.rofi}/bin/rofi -show drun -show-icons

      # change focus
      bindsym $mod+j focus left
      bindsym $mod+k focus down
      bindsym $mod+l focus up
      bindsym $mod+ae focus right

      # alternatively, you can use the cursor keys:
      bindsym $mod+Left focus left
      bindsym $mod+Down focus down
      bindsym $mod+Up focus up
      bindsym $mod+Right focus right

      # move focused window
      bindsym $mod+Shift+j move left
      bindsym $mod+Shift+k move down
      bindsym $mod+Shift+l move up
      bindsym $mod+Shift+ae move right

      # alternatively, you can use the cursor keys:
      bindsym $mod+Shift+Left move left
      bindsym $mod+Shift+Down move down
      bindsym $mod+Shift+Up move up
      bindsym $mod+Shift+Right move right

      # split in horizontal orientation
      bindsym $mod+h split h

      # split in vertical orientation
      bindsym $mod+v split v

      # enter fullscreen mode for the focused container
      bindsym $mod+f fullscreen toggle
      bindsym $mod+Shift+f focus parent; fullscreen toggle

      # change container layout (stacked, tabbed, toggle split)
      bindsym $mod+s layout stacking
      bindsym $mod+w layout tabbed
      bindsym $mod+e layout toggle split

      # toggle tiling / floating
      bindsym $mod+Shift+space floating toggle

      # change focus between tiling / floating windows
      bindsym $mod+space focus mode_toggle

      # focus the parent container
      bindsym $mod+a focus parent

      # focus the child container
      #bindsym $mod+d focus child

      # switch to workspace
      bindsym $mod+1 workspace 1
      bindsym $mod+2 workspace 2
      bindsym $mod+3 workspace 3
      bindsym $mod+4 workspace 4
      bindsym $mod+5 workspace 5
      bindsym $mod+6 workspace 6
      bindsym $mod+7 workspace 7
      bindsym $mod+8 workspace 8
      bindsym $mod+9 workspace 9
      bindsym $mod+0 workspace 10

      # move focused container to workspace
      bindsym $mod+Shift+1 move container to workspace 1
      bindsym $mod+Shift+2 move container to workspace 2
      bindsym $mod+Shift+3 move container to workspace 3
      bindsym $mod+Shift+4 move container to workspace 4
      bindsym $mod+Shift+5 move container to workspace 5
      bindsym $mod+Shift+6 move container to workspace 6
      bindsym $mod+Shift+7 move container to workspace 7
      bindsym $mod+Shift+8 move container to workspace 8
      bindsym $mod+Shift+9 move container to workspace 9
      bindsym $mod+Shift+0 move container to workspace 10

      # reload the configuration file
      bindsym $mod+Shift+c reload
      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      bindsym $mod+Shift+r restart
      # exit i3 (logs you out of your X session)
      bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

      # resize window (you can also use the mouse for that)
      mode "resize" {
              # These bindings trigger as soon as you enter the resize mode

              # Pressing left will shrink the window’s width.
              # Pressing right will grow the window’s width.
              # Pressing up will shrink the window’s height.
              # Pressing down will grow the window’s height.
              bindsym j resize shrink width 10 px or 10 ppt
              bindsym k resize grow height 10 px or 10 ppt
              bindsym l resize shrink height 10 px or 10 ppt
              bindsym ae resize grow width 10 px or 10 ppt

              # same bindings, but for the arrow keys
              bindsym Left resize shrink width 10 px or 10 ppt
              bindsym Down resize grow height 10 px or 10 ppt
              bindsym Up resize shrink height 10 px or 10 ppt
              bindsym Right resize grow width 10 px or 10 ppt

              # back to normal: Enter or Escape
              bindsym Return mode "default"
              bindsym Escape mode "default"
      }

      bindsym $mod+r mode "resize"

      bar {
          font pango:Fira Mono, FontAwesome 17
          position bottom
          status_command ${pkgs.i3status-rust}/bin/i3status-rs ${./i3status.toml}
          colors {
              separator #666666
              background #222222
              statusline #dddddd
              focused_workspace #0088CC #0088CC #ffffff
              active_workspace #333333 #333333 #ffffff
              inactive_workspace #333333 #333333 #888888
              urgent_workspace #2f343a #900000 #ffffff
          }
      }

      exec --no-startup-id sleep 0.5s; ${pkgs.feh}/bin/feh --bg-scale ${wallpaper}
      exec --no-startup-id ${pkgs.networkmanagerapplet}/bin/nm-applet
      exec --no-startup-id sleep 0.5s; ${pkgs.numlockx}/bin/numlockx on
    '';
  };
in
cfg