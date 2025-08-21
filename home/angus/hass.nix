{pkgs, ...}: {
  imports = [
    ./global.nix
  ];
  home.packages = [
    pkgs.luminance
    pkgs.brightnessctl
  ];
 }
