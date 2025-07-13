{pkgs, ...}: let 
  
in {
  systemd.services.init-mqtt-network = {
    description = "Create the network bridge for mqtt.";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      # Put a true at the end to prevent getting non-zero return code, which will
          	  # crash the whole service.
      if ! ${pkgs.podman}/bin/podman network exists mqtt-bridge; then
        ${pkgs.podman}/bin/podman network create mqtt-bridge
      else
      	    echo "mqtt-bridge already exists"
       fi
    '';
  };

  # Support DNS within bridge networks
  # c.f. https://github.com/NixOS/nixpkgs/issues/226365#issuecomment-2164985192
  networking.firewall.interfaces."podman+".allowedUDPPorts = [53 5353];

  networking.firewall.allowedTCPPorts = [80 443 1883 8123 8555 8989];
  networking.firewall.allowedUDPPorts = [5683 8555];
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
      containers.home-assistant = {
        environment.TZ = "Europe/London";
        # This fixes a bug
        environment.PYTHONPATH = "/usr/local/lib/python3.13:/config/deps";
        image = "ghcr.io/home-assistant/home-assistant:2025.7.1"; # Warning: if the tag does not change, the image will not be updated
        extraOptions = [
          "--network=host"
          "--cap-add=NET_RAW"
	  "--mount=type=tmpfs,destination=/config/www/snapshots"
          #"--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
        ];
        volumes = [
          "/etc/home-assistant:/config"
        ];
      };
      # SpeedTest
      containers.speedtest-tracker = {
        environment.TZ = "Europe/London";
        environment.SPEEDTEST_SCHEDULE = "0 */1 * * *";
        environment.APP_KEY = "base64:Xn3dUpdHB0Id07Q2KdLT5Qrf2MvgpSGkS6jL4cWXBWg=";
        ports = [
          "4898:80"
        ];
        image = "lscr.io/linuxserver/speedtest-tracker:1.6.0";
        volumes = [
          "/etc/speedtest-tracker/data:/config"
        ];
      };
      # Mosquitto
      containers.mosquitto = {
        ports = [
          "1883:1883"
          "9001:9001"
        ];
        image = "docker.io/eclipse-mosquitto:2.0.21";
        volumes = [
          "/etc/mosquitto/config:/mosquitto/config"
        ];
        extraOptions = [
          "--network=mqtt-bridge"
        ];
      };
      # Frigate
      containers.frigate = {
        environment = {
          FRIGATE_RTSP_PASSWORD = "password";
          LIBVA_DRIVER_NAME = "i965";
        };
        ports = [
          "8971:8971"
          # RTSP
          "8554:8554"
          # Internal unauth
          "5000:5000"
          # WebRTC over TCP
          "8555:8555/tcp"
          # WebRTC over UDP
          "8555:8555/udp"
          # go2rtc interface
          "1984:1984"
        ];
        image = "ghcr.io/blakeblackshear/frigate:0.15.0";
        extraOptions = [
          "--device=/dev/bus/usb"
          "--device=/dev/dri/renderD128"
          "--device=/dev/dri/renderD129"
          "--device=/dev/dri/card1"
          "--device=/dev/dri/card2"
          "--tmpfs=/tmp/cache:rw,size=1g,mode=1777"
          "--shm-size=256mb"
          "--network=mqtt-bridge"
          "--cap-add=PERFMON"
          "--group-add=keep-groups"
        ];
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/frigate/config:/config"
          "/mnt/data/media/frigate:/media/frigate"
        ];
      };
      # gluetun
      # Might need to order this before torrents: https://discourse.nixos.org/t/oci-containers-with-systemd-unit-dependencies/26029
      containers.gluetun = {
        environment = {
          VPN_SERVICE_PROVIDER = "windscribe";
          VPN_TYPE = "openvpn";
          SERVER_REGIONS = "United Kingdom";
        };

        ports = [
          # Ports for qbittorrent!
          "8080:8080"
          "6881:6881"
          "6881:6881/udp"
          # Ports for sonarr
          "8989:8989"
          # Ports for prowlarr
          "9696:9696"
        ];
        image = "docker.io/qmcgaw/gluetun:v3.40";
        volumes = [
          "/etc/gluetun/secrets:/run/secrets"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--device=/dev/net/tun"
        ];
      };
      # qbittorrent
      containers.qbittorrent = {
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
        image = "lscr.io/linuxserver/qbittorrent:5.0.4";
	dependsOn = [ "gluetun" ];
        volumes = [
          "/etc/qbittorrent/data:/config"
          "/mnt/data/media/torrent:/downloads"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      # Prowlarr
      containers.prowlarr = {
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
        image = "lscr.io/linuxserver/prowlarr:1.34.1";
	dependsOn = [ "gluetun" ];
        volumes = [
          "/etc/prowlarr/data:/config"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      # Sonarr
      containers.sonarr = {
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
        image = "lscr.io/linuxserver/sonarr:4.0.14";
	dependsOn = [ "gluetun" ];
        volumes = [
          "/etc/sonarr/data:/config"
          "/mnt/data/media/tv:/tv"
          "/mnt/data/media/torrent:/downloads"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      # Jellyfin
      containers.jellyfin = {
        environment = {
          PUID = "1000";
          PGID = "1000";

          LIBVA_DRIVER_NAME = "i965";
        };
        image = "lscr.io/linuxserver/jellyfin:10.10.7";
        volumes = [
          "/etc/jellyfin/data:/config"
          "/mnt/data/media/tv:/tv"
        ];
        ports = [
          "8096:8096"
          "7359:7359/udp"
          "1900:1900/udp"
        ];
        extraOptions = [
          "--device=/dev/dri/renderD129:/dev/dri/renderD129"
        ];
      };
    };
    containers.enable = true;
  };
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
