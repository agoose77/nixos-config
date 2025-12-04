{pkgs, ...}: {
  imports = [
    ./features/hyprland.nix
    ./features/hyprlock.nix
    ./global.nix
  ];
  home.packages = [
    pkgs.luminance
    pkgs.brightnessctl
  ];
  monitors = [
    {
      name = "eDP-1";
      primary = true;
      width = 1920;
      height = 1080;
    }
  ];
}
