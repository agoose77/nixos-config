{flake.modules.homeManager.obs-studio = {pkgs, ...}: {
  home.packages = with pkgs; [
    obs-studio
  ];
};}
