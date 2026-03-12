{flake.modules.nixos.power = {
  # Battery management
  powerManagement.enable = true;
  services.tlp.enable = true;
};}
