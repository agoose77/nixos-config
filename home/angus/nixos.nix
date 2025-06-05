{pkgs, ...}: {
  imports = [
    ./global
  ];
  home.packages = [
    pkgs.polychromatic
    pkgs.idle-monitor
  ];
}
