{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.helvetica-neue-lt-std
  ];
}
