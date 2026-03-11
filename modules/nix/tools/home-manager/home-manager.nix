{inputs, ...}: {
  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      ({lib, ...}: {
        home-manager = {
          verbose = true;
          useUserPackages = true;
          useGlobalPkgs = true;
        };
      })
    ];
  };
}
