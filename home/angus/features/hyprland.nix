{
  lib,
  pkgs,
  config,
  ...
}: {
  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
  };

  xdg.portal = {
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-hyprland
    ];
    configPackages = [pkgs.hyprland];
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      cursor = {
        no_hardware_cursors = true;
      };
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = map (
        m: "${m.name},${
          if m.enabled
          then "${toString m.width}x${toString m.height}@${toString m.refreshRate},${m.position},${m.scale}"
          else "disable"
        }"
      ) (config.monitors);

      workspace = map (m: "${m.workspace},monitor:${m.name}") (
        lib.filter (m: m.enabled && m.workspace != null) config.monitors
      );
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more

      # Execute your favorite apps at launch
      # exec-once = waybar & hyprpaper & firefox
      "exec-once" = [
        "dunst"
        "slack -u"
        "1password --silent"
        "discord --start-minimized"
        "element-desktop --hidden"
        "kdeconnect-indicator"
        # Waybar appears to start itself
        # "waybar"
      ];
      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      # Some default env vars.
      env = "XCURSOR_SIZE,24";

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input = {
        kb_layout = "gb";
        kb_variant = "";
        kb_model = "";
        kb_options = "compose:rctrl";
        kb_rules = "";

        follow_mouse = 2; # Focus follows mouse, but KB requires click

        touchpad = {
          natural_scroll = false;
          tap-to-click = false;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 2;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 0;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = "yes";

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 5, default"
          "borderangle, 1, 48, default"
          "fade, 1, 3, default"
          "workspaces, 1, 2, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "yes"; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_status = "master";
      };

      windowrulev2 = [
        "workspace 2 silent, class:^Slack$"
        "workspace 2 silent, class:^discord$"
      ];

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = "off";
      };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
      };

      ## Example per-device config
      ## See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      #"device:epic-mouse-v1" = {
      #  sensitivity = -0.5;
      #};

      "$mod" = "SUPER";
      bind = [
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s -5%"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "$mod, return, exec, alacritty"
        "$mod SHIFT, return, exec, firefox"
        "$mod SHIFT, Q, killactive, g"
        "$mod, SPACE, exec, wofi --show drun"
        "$mod SHIFT, SPACE, exec, wofi --show run"
        "$mod, M, exit, "
        "$mod, P, pseudo, # dwindle"
        "$mod, J, togglesplit, # dwindle"
        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # Move window with mainMod SHIFT + arrow keys
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        # Switch workspaces with mainMod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"
        # Carry window to a workspace
        "$mod ALT, 1, movetoworkspace, 1"
        "$mod ALT, 2, movetoworkspace, 2"
        "$mod ALT, 3, movetoworkspace, 3"
        "$mod ALT, 4, movetoworkspace, 4"
        "$mod ALT, 5, movetoworkspace, 5"
        "$mod ALT, 6, movetoworkspace, 6"
        "$mod ALT, 7, movetoworkspace, 7"
        "$mod ALT, 8, movetoworkspace, 8"
        "$mod ALT, 9, movetoworkspace, 9"
        "$mod ALT, 0, movetoworkspace, 10"
        # Empty workspace
        "$mod SHIFT, grave, movetoworkspacesilent, empty"
        "$mod ALT, grave, movetoworkspace, empty"
        "$mod, grave, workspace, empty"
        # Toggle fullscreen / floating
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"
        # Special workspaces
        "$mod CTRL, M, movetoworkspacesilent, special"
        "$mod CTRL, A, togglespecialworkspace"
        # Group
        "$mod, G, togglegroup"
        "$mod ALT, TAB, changegroupactive, b"
        "$mod, TAB, changegroupactive, f"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
  # Use uwsm to launch hyprland
  wayland.windowManager.hyprland.systemd.enable = false;
  programs.bash.profileExtra = lib.mkBefore ''
       if [[ "$(tty)" == /dev/tty1 ]] && uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
    fi  '';
}
