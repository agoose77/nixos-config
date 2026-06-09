# modules/dev-shell.nix
{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = [pkgs.sops];
    };
  };
}
