{flake.modules.homeManager.design = {pkgs, ...}: {
  home.packages = with pkgs; [
    gimp
    inkscape
  ];
};}
