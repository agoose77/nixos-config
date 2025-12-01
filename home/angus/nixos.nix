{pkgs, ...}: {
  imports = [
    ./global.nix
    ./features/niri.nix
  ];
  home.packages = [
    pkgs.polychromatic
    pkgs.idle-monitor
  ];
}
