{
  flake.modules.homeManager.fuzzel = {...}: {
    programs.fuzzel = {
      enable = true;
    };
    stylix.targets.fuzzel.enable = true;
  };
}
