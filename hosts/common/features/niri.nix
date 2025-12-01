{pkgs, ...}: {
  programs.niri.enable = true;
  security.polkit.enable = true; # polkit
  # XWayland
  environment.systemPackages = [pkgs.xwayland-satellite];
}
