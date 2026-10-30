# modules/dev-shell.nix
{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = [pkgs.sops];
    };
  };
}
