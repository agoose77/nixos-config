pkgs: {
  nvidia-offload = pkgs.callPackage ./nvidia-offload {};
  idle-monitor = pkgs.callPackage ./idle-monitor {};
  duo-display = pkgs.callPackage ./duo-display {};
}
