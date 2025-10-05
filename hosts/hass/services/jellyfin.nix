{
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
      "/mnt/data/media/film:/film"
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
}
