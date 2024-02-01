# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
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
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.wlrootsNvidia
    ];
  # Configure your nixpkgs instance
	  config = {
	    # Disable if you don't want unfree packages
	    allowUnfree = true;
	    # Workaround for https://github.com/nix-community/home-manager/issues/2942
	    allowUnfreePredicate = _: true;
	  };
  };
 
  home = {
    username = "angus";
    homeDirectory = "/home/angus";

    packages =  with pkgs; [
    	discord
    	element-desktop-wayland
    	spotify
	  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	  stateVersion = "23.05";
  };

	accounts.email = {
		accounts."goosey15@gmail.com" = {
		  primary = true;
			address = "goosey15@gmail.com";
			flavor = "gmail.com";
			realName = "Angus Hollands";
			thunderbird.enable = true;
		};
		accounts."ahollands@2i2c.org" = {
			address = "ahollands@2i2c.org";
			flavor = "gmail.com";
			realName = "Angus Hollands";
			thunderbird.enable = true;
		};
		accounts."angus.hollands@outlook.com" = {
			address = "angus.hollands@outlook.com";
			flavor = "outlook.office365.com";
			realName = "Angus Hollands";
			thunderbird.enable = true;
		};
	};

	programs.thunderbird = {
		enable = true;
		profiles.default = {
			isDefault = true;
			
		};
	};

	# Setup nixvim
	programs.nixvim.enable = true;
	
	# Enable home-manager
  programs.home-manager.enable = true;

	programs.gh = {
		enable = true;
	};
 
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

	programs.bash.enable = true;

	programs.nushell = {
		enable = true;
		extraConfig = ''
     $env.config = {
      show_banner: false
     }
     def git_current_branch () {
       git branch --show-current | str trim -c "\n"
     }
     '';
     shellAliases = {     
				s = "git status -sb";
				g = "git";
				ga = "git add";
				gaa = "git add --all";
				gapa = "git add --patch";
				gau = "git add --update";
				gb = "git branch";
				gba = "git branch -a";
				gbd = "git branch -d";
				gbl = "git blame -b -w";
				gbnm = "git branch --no-merged";
				gbr = "git branch --remote";
				gbs = "git bisect";
				gbsb = "git bisect bad";
				gbsg = "git bisect good";
				gbsr = "git bisect reset";
				gbss = "git bisect start";
				gc = "git commit -v";
				"gc!" = "git commit -v --amend";
				gca = "git commit -v -a";
				"gca!" = "git commit -v -a --amend";
				gcam = "git commit -a -m";
				"gcan!" = "git commit -v -a --no-edit --amend";
				"gcans!" = "git commit -v -a -s --no-edit --amend";
				gcb = "git checkout -b";
				gcd = "git checkout develop";
				gcf = "git config --list";
				gcl = "git clone --recursive";
				gclean = "git clean -fd";
				gcm = "git checkout master";
				gcmsg = "git commit -m";
				"gcn!" = "git commit -v --no-edit --amend";
				gco = "git checkout";
				gcount = "git shortlog -sn";
				gcp = "git cherry-pick";
				gcpa = "git cherry-pick --abort";
				gcpc = "git cherry-pick --continue";
				gcs = "git commit -S";
				gcsm = "git commit -s -m";
				gd = "git diff";
				gdca = "git diff --cached";
				gdt = "git diff-tree --no-commit-id --name-only -r";
				gdw = "git diff --word-diff";
				gf = "git fetch";
				gfa = "git fetch --all --prune";
				gfo = "git fetch origin";
				gg = "git gui citool";
				gga = "git gui citool --amend";
				ggpull = "git pull origin (git_current_branch)";
				ggpur = "ggu";
				ggpush = "git push origin (git_current_branch)";
				ggsup = "git branch --set-upstream-to=origin/(git_current_branch)";
				ghh = "git help";
				gignore = "git update-index --assume-unchanged";
				gk = "gitk --all --branches";
				gke = "gitk --all (git log -g --pretty=%h)";
				gl = "git pull";
				glg = "git log --stat";
				glgg = "git log --graph";
				glgga = "git log --graph --decorate --all";
				glgm = "git log --graph --max-count=10";
				glgp = "git log --stat -p";
				glo = "git log --oneline --decorate";
				globurl = "noglob urlglobber";
				glog = "git log --oneline --decorate --graph";
				gloga = "git log --oneline --decorate --graph --all";
				glol = "git log --graph --pretty=\%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\ --abbrev-commit";
				glola = "git log --graph --pretty=\%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\ --abbrev-commit --all";
				glp = "_git_log_prettily";
				glum = "git pull upstream master";
				gm = "git merge";
				gmom = "git merge origin/master";
				gmt = "git mergetool --no-prompt";
				gmtvim = "git mergetool --no-prompt --tool=vimdiff";
				gmum = "git merge upstream/master";
				gp = "git push";
				gpd = "git push --dry-run";
				gpf = "git push --force-with-lease";
				#gpoat = "(git push origin --all; git push origin --tags)";
				#gpristine = "(git reset --hard; git clean -dfx)";
				gpsup = "git push --set-upstream origin (git_current_branch)";
				gpu = "git push upstream";
				gpv = "git push -v";
				gr = "git remote";
				gra = "git remote add";
				grb = "git rebase";
				grba = "git rebase --abort";
				grbc = "git rebase --continue";
				grbi = "git rebase -i";
				grbm = "git rebase master";
				grbs = "git rebase --skip";
				grep = "grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}";
				grh = "git reset HEAD";
				grhh = "git reset HEAD --hard";
				grm = "git rm";
				grmc = "git rm --cached";
				grmv = "git remote rename";
				grrm = "git remote remove";
				grset = "git remote set-url";
				grss = "git restore --source";
				grst = "git restore --staged";
				#grt = "cd (git rev-parse --show-toplevel || echo '.')";
				gru = "git reset --";
				grup = "git remote update";
				grv = "git remote -v";
				gsb = "git status -sb";
				gsd = "git svn dcommit";
				gsi = "git submodule init";
				gsps = "git show --pretty=short --show-signature";
				gsr = "git svn rebase";
				gss = "git status -s";
				gst = "git status";
				gsta = "git stash save";
				gstaa = "git stash apply";
				gstc = "git stash clear";
				gstd = "git stash drop";
				gstl = "git stash list";
				gstp = "git stash pop";
				gsts = "git stash show --text";
				gsu = "git submodule update";
				gsw = "git switch";
				gswc = "git switch -c";
				gts = "git tag -s";
				#gtv = "(git tag | sort -V)";
				gunignore = "git update-index --no-assume-unchanged";
				gup = "git pull --rebase";
				gupv = "git pull --rebase -v";
				gwch = "git whatchanged -p --abbrev-commit --pretty=medium";
     };
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
