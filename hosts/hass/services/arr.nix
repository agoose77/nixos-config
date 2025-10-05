{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    # "prowlarr-token" = {
    #   format = "yaml";
    #   # can be also set per secret
    #   sopsFile = ../secrets.yaml;
    #   mode = "0555";
    # };

    windscribe-username = {
      sopsFile = ../secrets.yaml;
      owner = "root";
      mode = "0555";
      key = "windscribe-username";
    };
    windscribe-password = {
      sopsFile = ../secrets.yaml;
      owner = "root";
      mode = "0555";
      key = "windscribe-password";
    };
  };
  # gluetun
  # Might need to order this before torrents: https://discourse.nixos.org/t/oci-containers-with-systemd-unit-dependencies/26029
  virtualisation.oci-containers = {
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
        "${config.sops.secrets.windscribe-username.path}:/run/secrets/openvpn_user"
        "${config.sops.secrets.windscribe-password.path}:/run/secrets/openvpn_password"
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
      image = "lscr.io/linuxserver/qbittorrent:5.1.2";
      dependsOn = ["gluetun"];
      volumes = [
        "/etc/qbittorrent/data:/config"
        "/mnt/data/media/torrent:/downloads"
      ];
      extraOptions = [
        "--network=container:gluetun"
      ];
    };
    # Prowlarr
    containers.prowlarr = let
      prowlarrConfig = {
        Config = {
          BindAddress = "*";
          Port = "9696";
          SslPort = "6969";
          EnableSsl = "False";
          LaunchBrowser = "True";
          AuthenticationMethod = "External";
          Branch = "master";
          LogLevel = "debug";
          SslCertPath = "";
          SslCertPassword = "";
          UrlBase = "/prowlarr";
          InstanceName = "Prowlarr";
          UpdateMechanism = "Docker";
        };
      };
      prowlarrConfigFile = (pkgs.formats.xml {}).generate "config.xml" prowlarrConfig;
    in {
      environment = {
        PUID = "1000";
        PGID = "1000";
      };
      image = "lscr.io/linuxserver/prowlarr:2.0.5";
      dependsOn = ["gluetun"];
      volumes = [
        "${prowlarrConfigFile}:/config/config.xml:rw"
        "/etc/prowlarr/data:/config"
      ];
      extraOptions = [
        "--network=container:gluetun"
      ];
    };
    # Sonarr
    containers.sonarr = let
      sonarrConfig = {
        Config = {
          BindAddress = "*";
          Port = "8989";
          SslPort = "9898";
          EnableSsl = "False";
          LaunchBrowser = "True";
          AuthenticationMethod = "External";
          Branch = "main";
          LogLevel = "debug";
          SslCertPath = "";
          SslCertPassword = "";
          UrlBase = "/sonarr";
          InstanceName = "Sonarr";
          UpdateMechanism = "Docker";
        };
      };
      sonarrConfigFile = (pkgs.formats.xml {}).generate "config.xml" sonarrConfig;
    in {
      environment = {
        PUID = "1000";
        PGID = "1000";
      };
      image = "lscr.io/linuxserver/sonarr:4.0.15";
      dependsOn = ["gluetun"];
      volumes = [
        "${sonarrConfigFile}:/config/config.xml:rw"
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
        LIBVA_DRIVER_NAME = "iHD";
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
        "--device=/dev/dri"
      ];
    };
  };
}
