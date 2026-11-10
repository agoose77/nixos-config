{
  flake.modules.nixos.power = {
    # Battery management
    powerManagement.enable = true;

    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
  };
}
