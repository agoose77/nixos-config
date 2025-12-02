{
  inputs,
  lib,
  config,
  ...
}: {
  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;
  nix = {
    nixPath = ["/etc/nix/path"];
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      # Keep the last 3 generations
      options = "--delete-older-than +3";
    };
  };
}
