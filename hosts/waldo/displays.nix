{pkgs, ...}: {
  services.zenbook-display = {
    enable = true;
    package = pkgs.duo-display-niri;
  };
}
