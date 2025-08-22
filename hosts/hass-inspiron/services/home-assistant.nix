{
  # Open shelly port
  networking.firewall.allowedUDPPorts = [5683];

  virtualisation.oci-containers.containers.home-assistant = {
    environment.TZ = "Europe/London";
    # This fixes a bug
    environment.PYTHONPATH = "/usr/local/lib/python3.13:/config/deps";
    image = "ghcr.io/home-assistant/home-assistant:2025.8.2"; # Warning: if the tag does not change, the image will not be updated
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
}
