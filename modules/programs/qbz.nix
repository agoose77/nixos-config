{
  flake.modules = {
    nixos.qbz = {pkgs, ...}: {
      environment.systemPackages = [pkgs.qbz];
    };
  };
}
