{
  virtualisation.oci-containers.containers.mosquitto = {
    ports = [
      "1883:1883"
      "9001:9001"
    ];
    image = "docker.io/eclipse-mosquitto:2.0.22";
    volumes = [
      "/etc/mosquitto/config:/mosquitto/config"
    ];
    extraOptions = [
      "--network=mqtt-bridge"
    ];
  };
}
