{inputs, ...}: {
  flake.modules.nixos.zenbook-duo-daemon = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.zenbook-duo-daemon.nixosModules.default];

    # In your NixOS configuration module
    services.zenbook-duo-daemon.package = inputs.zenbook-duo-daemon.packages.x86_64-linux.default;
  };
}
