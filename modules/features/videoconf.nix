{flake.modules.homeManager.videoconf = {pkgs, ...}: {
  home.packages = with pkgs; [
    discord
    slack
    zoom-us
  ];
};}
