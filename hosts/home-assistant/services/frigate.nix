{
  networking.firewall.allowedTCPPorts = [8555];
  networking.firewall.allowedUDPPorts = [8555];
  virtualisation.oci-containers.containers.frigate = {
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
    image = "ghcr.io/blakeblackshear/frigate:0.16.0";
    extraOptions = [
      "--device=/dev/bus/usb"
      "--device=/dev/dri/renderD128"
      "--device=/dev/dri/renderD129"
      "--device=/dev/dri/card0"
      "--device=/dev/dri/card1"
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
}
