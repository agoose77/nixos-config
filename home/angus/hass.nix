{pkgs, ...}: {
  imports = [
    ./features/hyprland.nix
    ./features/hyprlock.nix
    ./global.nix
  ];
  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      workspace = "1";
      primary = true;
      enabled = false;
    }
  ];
  home.packages = [
    pkgs.luminance
    pkgs.brightnessctl
  ];
}
