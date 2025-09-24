# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}: {
  # You can import other home-manager modules here
  imports =
    (builtins.attrValues outputs.homeManagerModules)
    ++ [
      inputs.stylix.homeModules.stylix
      ./features/stylix.nix
      ./features/hyprland.nix
      ./features/hyprlock.nix
      ./features/waybar.nix
      ./features/cli.nix
      ./features/git.nix
      ./features/email.nix
      ./features/firefox.nix
      ./features/nixvim.nix
      ./features/rio.nix
      ./features/fonts.nix
      ./features/wofi.nix
      ./features/notes.nix
      ./features/kdeconnect.nix
      ./features/spotify.nix
      ./features/playerctl.nix
      ./features/notifications.nix
      ./features/videoconf.nix
      ./features/design.nix
      ./features/wlsunset.nix
    ];
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

  home = {
    username = "angus";
    homeDirectory = "/home/${config.home.username}";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
  };

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

  home.sessionVariables = {
    # Make it hard to accidentally nest kubeconfig contexts in 2i2c's deployer infra
    DEPLOYER_NO_NESTED_KUBECONFIG = "1";
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
  };

  # Prevent kubeconfig being used
  home.file.".kube/config".text = ''
  '';
}
