{
  config,
  pkgs,
  ...
}: let
  domainName = "home-assistant";
in {
  networking.firewall.allowedTCPPorts = [80 443];

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
    virtualHosts."${domainName}.tail12edf.ts.net".extraConfig = ''
      reverse_proxy localhost:8123


      redir /jellyfin /jellyfin/
      reverse_proxy /jellyfin/* localhost:8096

      redir /sonarr /sonarr/
      reverse_proxy /sonarr/* localhost:8989

      redir /prowlarr /prowlarr/
      reverse_proxy /prowlarr/* localhost:9696

      redir /qbittorrent /qbittorrent/
      handle_path /qbittorrent/* {
       reverse_proxy localhost:8080
      }
    '';

    # For local routing
    virtualHosts."${config.networking.hostName}.local".extraConfig = virtualHosts."${domainName}.tail12edf.ts.net".extraConfig;

    # For HTTP-only local routing
    virtualHosts."${config.networking.hostName}.local:80".extraConfig = virtualHosts."${domainName}.tail12edf.ts.net".extraConfig;
  };
}
