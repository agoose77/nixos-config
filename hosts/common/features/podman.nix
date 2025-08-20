{config, ...}: let
  dockerEnabled = config.virtualisation.docker.enable;
in {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = !dockerEnabled;
      dockerSocket.enable = !dockerEnabled;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    containers.enable = true;
  };
  # Support DNS within bridge networks
  # c.f. https://github.com/NixOS/nixpkgs/issues/226365#issuecomment-2164985192
  networking.firewall.interfaces."podman+".allowedUDPPorts = [53 5353];
}
