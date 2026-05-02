# See https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md for setup instructions
{
  flake.modules.nixos.auto-upgrade = {
    pkgs,
    config,
    ...
  }: {
    system.autoUpgrade = let
      hostname = config.networking.hostName;
    in {
      enable = true;
      allowReboot = true;
      dates = "*-*-* 04:00:00";
      randomizedDelaySec = "1h";
      runGarbageCollection = true;
      upgrade = false; # Use existing lockfile
      flake = "github:agoose77/nixos-config#${hostname}";
    };
  };
}
