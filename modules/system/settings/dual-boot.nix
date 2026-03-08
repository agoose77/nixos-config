{
  flake.modules.nixos.dual-boot = {
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
