{
  inputs,
  withSystem,
  ...
}: {
  imports = [
    inputs.pkgs-by-name-for-flake-parts.flakeModule
  ];

  perSystem = {system, ...}: {
    pkgsDirectory = inputs.packages;
  };

  flake = {
    overlays.default = _final: prev: {
      local = withSystem prev.stdenv.hostPlatform.system ({config, ...}: config.packages);
    };
  };
}
