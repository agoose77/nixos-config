{
  flake.modules.nixos.harmonia = {
    config,
    pkgs,
    ...
  }: {
    services.harmonia.cache = {
      enable = true;
      settings = {
        bind = "localhost:5999";
      };
    };
    networking.firewall.allowedTCPPorts = [443 80];
    services.harmonia.cache.signKeyPaths = [config.sops.secrets.harmonia-key.path];

    # Public key cache.local:J6dMlX0ZxNYcZsaeqdIEUVS1Thzt4n4Ds+OOy8r8zs4=
    sops.secrets.harmonia-key = {
      sopsFile = ./secrets.yaml;
      owner = "root";
      mode = "0555";
      key = "harmonia-private-key";
    };
    # Allow Caddy to user to manage and create certs
    # TODO: move this to mkif
    services.tailscale.permitCertUid = "caddy";

    environment.systemPackages = [
      pkgs.nss
      pkgs.nssTools
    ];

    services.caddy = rec {
      enable = true;

      globalConfig = ''
        auto_https disable_redirects
      '';

      # Auto-HTTPS remote routing
      virtualHosts."${config.networking.hostName}.tail12edf.ts.net".extraConfig = ''
        redir /nix-cache /nix-cache/
        reverse_proxy /nix-cache/* localhost:5999
      '';

      # For local routing
      virtualHosts."${config.networking.hostName}.local".extraConfig = virtualHosts."${config.networking.hostName}.tail12edf.ts.net".extraConfig;
    };
  };
}
