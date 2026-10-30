{inputs, ...}: {
  flake.modules.nixos.sops = {config, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops.environment.SOPS_AGE_SSH_PRIVATE_KEY_FILE = "/etc/ssh/ssh_host_ed25519_key";
  };
}
