{...}: {
  # default settings needed for all homeManagerConfigurations

  flake.modules.homeManager.system-minimal = {
    config,
    ...
  }: {
    home.homeDirectory = "/home/${config.home.username}";
    home.stateVersion = "23.11";
  };
}
