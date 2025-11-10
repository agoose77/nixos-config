{pkgs, ...}: {
  # Jellyfin
  virtualisation.oci-containers.containers.jellyfin = let
    networkConfig = {
      NetworkConfiguration = {
        BaseUrl = "/jellyfin";
        EnableHttps = "false";
        RequireHttps = "false";
        InternalHttpPort = "8096";
        InternalHttpsPort = "8920";
        PublicHttpPort = "8096";
        PublicHttpsPort = "8920";
        AutoDiscovery = "true";
        EnableUPnP = "false";
        EnableIPv4 = "true";
        EnableIPv6 = "false";
        EnableRemoteAccess = "true";
        LocalNetworkSubnets = "";
        LocalNetworkAddresses = "";
        KnownProxies = "";
        IgnoreVirtualInterfaces = "true";
        VirtualInterfaceNames = {
          string = "veth";
        };
        EnablePublishedServerUriByRequest = "false";
        PublishedServerUriBySubnet = "";
        RemoteIPFilter = "";
        IsRemoteIPFilterBlacklist = "false";
      };
    };
    networkConfigFile = (pkgs.formats.xml {}).generate "network.xml" networkConfig;
  in {
    environment = {
      PUID = "1000";
      PGID = "1000";
      LIBVA_DRIVER_NAME = "iHD";
    };
    image = "lscr.io/linuxserver/jellyfin:10.11.2";
    volumes = [
      "/etc/jellyfin/data:/config"
      "${networkConfigFile}:/config/network.xml:ro"
      "/mnt/data/media/tv:/tv"
      "/mnt/data/media/film:/film"
    ];
    ports = [
      "8096:8096"
      "7359:7359/udp"
      #"1900:1900/udp"
    ];
    extraOptions = [
      "--device=/dev/dri"
    ];
  };
}
