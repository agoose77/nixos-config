pkgs: {
  nvidia-offload = pkgs.callPackage ./nvidia-offload {};
  idle-monitor = pkgs.callPackage ./idle-monitor {};
  duo-display-hyprland = pkgs.callPackage ./duo-display-hyprland {};
  myst = pkgs.callPackage ./myst {};
  throttlestop = pkgs.callPackage ./throttlestop {};
}
