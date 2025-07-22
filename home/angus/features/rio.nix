{pkgs, ...}: {
  programs.rio = {
    enable = true;
    settings = {
      "confirm-before-quit" = false;
    };
  };
}
