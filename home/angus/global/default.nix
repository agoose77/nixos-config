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
  imports =
    [
      inputs.stylix.homeModules.stylix
      ../features/hyprland.nix
      ../features/hyprlock.nix
      ../features/waybar.nix
      ../features/git.nix
      ../features/email.nix
      ../features/firefox.nix
      ../features/nixvim.nix
      ../features/rio.nix
      ../features/fonts.nix
      ../features/wofi.nix
      ../features/notes.nix
      ../features/stylix.nix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    # Apply all overlays
    overlays = builtins.attrValues outputs.overlays;
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home = {
    username = "angus";
    homeDirectory = "/home/angus";

    packages = with pkgs; [
      discord
      element-desktop
      openssh
      spotify
      sd
      watchexec
      comby
      hyprshot
    ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
  };

  programs.ripgrep.enable = true;

  # Enable home-manager
  programs.home-manager.enable = true;
  # programs.ssh = {
  #   enable = true;
  #   extraConfig = "IdentityAgent ~/.1password/agent.sock";
  # };
  # Write SHH config with correct permissions
  home.activation.copySshConfig = let
    cfgFile = pkgs.writeText "ssh-config" ''
      Host *
        ForwardAgent no
        AddKeysToAgent no
        Compression no
        ServerAliveInterval 0
        ServerAliveCountMax 3
        HashKnownHosts no
        UserKnownHostsFile ~/.ssh/known_hosts
        ControlMaster no
        ControlPath ~/.ssh/master-%r@%n:%p
        ControlPersist no

        IdentityAgent ~/.1password/agent.sock

    '';
  in
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      install -m600 -D ${cfgFile} $HOME/.ssh/config
    '';

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.bash.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      gcloud = {
        disabled = true;
      };
      kubernetes = {
        disabled = false;
        contexts = [
          {
            context_pattern = "^arn:aws:eks.*:cluster/(.*)$";
            context_alias = "aws.$1";
          }
          {
            context_pattern = "^gke.*_([^_]*)$";
            context_alias = "gcp.$1";
          }
        ];
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
  home.sessionVariables = {
    # Make it hard to accidentally nest kubeconfig contexts in 2i2c's deployer infra
    DEPLOYER_NO_NESTED_KUBECONFIG = "1";
    _ZO_DOCTOR = "0";
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
  };

  programs.btop.enable = true;
  programs.eza.enable = true;

  # Prevent kubeconfig being used
  home.file.".kube/config".text = ''
  '';
}
