{pkgs, ...}: {
  # Disable eDP-2 when keyboard plugged in
  services.udev.extraRules = ''
    ACTION=="add",    ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="1b2c", RUN+="${pkgs.duo-display}/bin/duo-display top"
    ACTION=="remove", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="1b2c", RUN+="${pkgs.duo-display}/bin/duo-display both"
  '';
}
