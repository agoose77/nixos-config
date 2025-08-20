{
  outputs,
  config,
  ...
}: {
  imports = [
    ./features/cli.nix
    ./features/git.nix
    ./features/nixvim.nix
    ./features/rio.nix
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
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
