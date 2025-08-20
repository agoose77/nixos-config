{
  networking.firewall.allowedTCPPorts = [80];

  services.caddy = rec {
    enable = true;

    # Auto-HTTPS remote routing
    virtualHosts."home-assistant.tail12edf.ts.net".extraConfig = ''
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

    # For HTTP-only local routing
    virtualHosts."home-assistant.local".extraConfig = virtualHosts."home-assistant.tail12edf.ts.net".extraConfig;
  };
}
