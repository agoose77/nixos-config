# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {


  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];
  nixpkgs = {
  # Configure your nixpkgs instance
	  config = {
	    # Disable if you don't want unfree packages
	    allowUnfree = true;
	    # Workaround for https://github.com/nix-community/home-manager/issues/2942
	    allowUnfreePredicate = _: true;
	  };
  };
 
  # TODO: Set your username
  home = {
    username = "angus";
    homeDirectory = "/home/angus";

    packages =  with pkgs; [
	    spotify
	  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	  stateVersion = "23.05";
  };

	# Enable home-manager
  programs.home-manager.enable = true;
 
  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  programs.firefox.enable = true;
  programs.git = {
    enable = true;
    userName = "Angus Hollands";
    userEmail = "goosey15@gmail.com";
    lfs.enable = true;
  };
  programs.ssh = {
    enable = true;
    extraConfig = "IdentityAgent ~/.1password/agent.sock";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";


	programs.direnv = {
		enable = true;
		enableNushellIntegration = true;
	};

	programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
  };

	programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

	programs.nushell = {
		enable = true;
		extraConfig = ''
     $env.config = {
      show_banner: false
     }
     '';
	};

  programs.starship = { 
    enable = true;
  };

  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {
    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = ",preferred,auto,auto";

    # See https://wiki.hyprland.org/Configuring/Keywords/ for more

    # Execute your favorite apps at launch
    # exec-once = waybar & hyprpaper & firefox
    "exec-once" = [
    	"dunst"
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
      kb_options = "";
      kb_rules = "";

      follow_mouse = 1;

      touchpad = {
        natural_scroll = "no";
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

      drop_shadow = "yes";
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
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
      new_is_master = true;
    };

    gestures = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = "off";
    };

    misc = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
    };

    # Example per-device config
    # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
    "device:epic-mouse-v1" = {
      sensitivity = -0.5;
    };

    "$mod" = "SUPER";
    bind = [
      "$mod, return, exec, alacritty"
      "$mod SHIFT, return, exec, firefox"
      "$mod SHIFT, Q, killactive, g"
      "$mod, SPACE, exec, wofi --show drun"
      "$mod SHIFT, SPACE, exec, wofi --show run"
      "$mod, M, exit, "
      "$mod, E, exec, dolphin"
      "$mod, V, togglefloating, "
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
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"
      # Example special workspace (scratchpad)
      "$mod CTRL, A, togglespecialworkspace, magic"
      "$mod CTRL, M, movetoworkspace, special:magic"
      # Scroll through existing workspaces with mainMod + scroll
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"
    ];
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
