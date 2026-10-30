{flake.modules.homeManager.kitty = {...}: {
  programs.kitty = {
    enable = true;
    # Temporary fix for https://github.com/kovidgoyal/kitty/issues/10102
    settings.auto_reload_config = -1;
  };
  stylix.targets.kitty.enable = true;
};}
