{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    helvetica-neue-lt-std
    roboto-slab
    noto-fonts
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    font-awesome
    material-design-icons
  ];
}
