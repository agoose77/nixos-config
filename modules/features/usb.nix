{
  flake.modules = {
    nixos.usb = {
      services.udisks2.enable = true;
      services.devmon.enable = true;
    };
    homeManager.usb = {pkgs, ...}: {
      services.udiskie.enable = true;
    };
  };
}
