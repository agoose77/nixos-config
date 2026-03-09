{
  flake.modules.homeManager.usb = {pkgs, ...}: {
    services.udiskie.enable = true;
  };
}
