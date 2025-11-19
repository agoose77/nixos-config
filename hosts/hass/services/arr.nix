{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    sonarr-api-key = {
      format = "yaml";
      # can be also set per secret
      sopsFile = ../secrets.yaml;
      mode = "0555";
    };

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

  # Sonarr
  sops.templates."sonar-config.xml".content = let
    sonarrConfig = {
      Config = {
        BindAddress = "*";
        Port = "8989";
        SslPort = "9898";
        EnableSsl = "False";
        LaunchBrowser = "True";
        AuthenticationMethod = "External";
        ApiKey = "${config.sops.placeholder.sonarr-api-key}";
        Branch = "main";
        LogLevel = "debug";
        SslCertPath = "";
        SslCertPassword = "";
        UrlBase = "/sonarr";
        InstanceName = "Sonarr";
        UpdateMechanism = "Docker";
      };
    };
  in
    (pkgs.formats.xml {}).generate "config.xml" sonarrConfig;

  virtualisation.oci-containers.containers = {
    # gluetun
    gluetun = {
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
        # Ports for radarr
        "7878:7878"
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
    qbittorrent = {
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
    prowlarr = let
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
      image = "lscr.io/linuxserver/prowlarr:2.1.5";
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
    sonarr = {
      environment = {
        PUID = "1000";
        PGID = "1000";
      };
      image = "lscr.io/linuxserver/sonarr:4.0.16";
      dependsOn = ["gluetun"];
      volumes = [
        "${config.sops.template."sonar-config.xml"}:/config/config.xml:rw"
        "/etc/sonarr/data:/config"
        "/mnt/data/media/tv:/tv"
        "/mnt/data/media/torrent:/downloads"
      ];
      extraOptions = [
        "--network=container:gluetun"
      ];
    };
    # Radarr
    radarr = let
      radarrConfig = {
        Config = {
          BindAddress = "*";
          Port = "7878";
          SslPort = "7878";
          EnableSsl = "False";
          LaunchBrowser = "True";
          AuthenticationMethod = "External";
          Branch = "main";
          LogLevel = "debug";
          SslCertPath = "";
          SslCertPassword = "";
          UrlBase = "/radarr";
          InstanceName = "Radarr";
          UpdateMechanism = "Docker";
        };
      };
      radarrConfigFile = (pkgs.formats.xml {}).generate "config.xml" radarrConfig;
    in {
      environment = {
        PUID = "1000";
        PGID = "1000";
      };
      image = "lscr.io/linuxserver/radarr:5.28.0";
      dependsOn = ["gluetun"];
      volumes = [
        "${radarrConfigFile}:/config/config.xml:rw"
        "/etc/radarr/data:/config"
        "/mnt/data/media/film:/film"
        "/mnt/data/media/torrent:/downloads"
      ];
      extraOptions = [
        "--network=container:gluetun"
      ];
    };
  };
}
