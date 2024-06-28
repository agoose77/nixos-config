{pkgs, ...}: {
  imports = [./global];
  home.packages = [pkgs.polychromatic];
}
