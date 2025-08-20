{
  config,
  lib,
  outputs,
  ...
}: let
  hosts = ["nixos" "home-assistant"]; #lib.attrNames outputs.nixosConfigurations;
in {
  # Make other hosts known ahead of time
  programs.ssh = {
    # Each hosts public key
    knownHosts = lib.genAttrs hosts (hostname: {
      publicKeyFile = ../../${hostname}/ssh_host_ed25519_key.pub;
      extraHostNames =
        # Alias for localhost if it's the same host
        lib.optional (hostname == config.networking.hostName) "localhost";
    });
  };
  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
