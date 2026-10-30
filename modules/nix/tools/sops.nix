{inputs, ...}: {
  flake.modules = {
    nixos.sops = {config, ...}: let
      hostKey = builtins.head (builtins.filter (k: k.type == "ed25519") config.services.openssh.hostKeys);
    in {
      imports = [inputs.sops-nix.nixosModules.sops];

      # Use the host's SSH private key by default.
      # The default loader that reads openssh' config converts the private
      # keys into an age key, which is different to the native SSH support now in sops
      # Instead, we specify the key manually.
      # c.f. https://github.com/travisty-/dotfiles/blob/df7fb8e7d439f65bfc82abe524147fb9f7956e7c/modules/features/shared/secrets.nix#L37+
      sops.environment.SOPS_AGE_SSH_PRIVATE_KEY_FILE = hostKey.path;
    };
    # Do not define home-manager module here.
    # Require the sops-1password aspect instead
  };
}
