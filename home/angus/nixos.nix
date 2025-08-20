{pkgs, ...}: {
  imports = [
    ./global.nix
  ];
  home.packages = [
    pkgs.polychromatic
    pkgs.idle-monitor
  ];
}
