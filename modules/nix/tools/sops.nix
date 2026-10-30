{inputs, ...}: {
  flake.modules.nixos.sops = {config, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
  };
}
