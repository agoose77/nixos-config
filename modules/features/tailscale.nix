{
  flake.modules.nixos.tailscale =
    # Set basic bootloader options
    {
      config,
      lib,
      pkgs,
      ...
    }: {
      services.tailscale = {
        enable = true;
        port = 12345;
      };

      networking.firewall.allowedUDPPorts = [config.services.tailscale.port];

      systemd.services.restart-tailscale-on-resume = {
        description = "Restart Tailscale after suspend.";
        wantedBy = ["suspend.target"];
        after = ["suspend.target"];
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
        };
        script = ''
          #!/usr/bin/env bash
          set -eu
          ${lib.getExe' pkgs.systemd "systemctl"} --no-block restart tailscaled.service
        '';
      };
    };
}
