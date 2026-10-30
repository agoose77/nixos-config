{inputs, ...}: {
  flake.modules = {
    homeManager.sops-1password = {
      pkgs,
      lib,
      ...
    }: let
      sshKeyCommand = "op read \"op://Private/SSH Key/private key\"";
    in {
      # Enable sops with home-manager
      imports = [inputs.sops-nix.homeManagerModules.sops];

      # Allow regular users to run sops as <me>
      home.sessionVariables.SOPS_AGE_SSH_PRIVATE_KEY_CMD = sshKeyCommand;

      # Allow config switch to access setuid binary sops
      sops.environment = {
        PATH = lib.mkForce "/run/wrappers/bin"; # op read
        SOPS_AGE_SSH_PRIVATE_KEY_CMD = sshKeyCommand;
      };
    };
  };
}
