{pkgs, ...}: {
  # Disable eDP-2 when keyboard plugged in
  services.udev.extraRules = ''
    ACTION==""add"",    ATTRS{idVendor}==""0b05"", ATTRS{idProduct}==""1b2c"", ENV{DISPLAY}="":0"", ENV{XAUTHORITY}=""/home/mfenniak/.Xauthority"", RUN+=""${pkgs.wlr-randr} --output eDP-2 --off""
    ACTION==""remove"", ATTRS{idVendor}==""0b05"", ATTRS{idProduct}==""1b2c"", ENV{DISPLAY}="":0"", ENV{XAUTHORITY}=""/home/mfenniak/.Xauthority"", RUN+=""${pkgs.wlr-randr} --output eDP-2 --on""
  '';
}
