# Set basic bootloader options
{config, ...}: {
  services.tailscale = {
    enable = true;
    port = 12345;
  };

  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
}
