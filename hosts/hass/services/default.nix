{pkgs, ...}: {
  imports = [
    ./home-assistant.nix
    # ./arr.nix TODO HASS
    ./frigate.nix
    ./mosquitto.nix
    # ./speedtest.nix TODO hass
    ./caddy.nix
  ];
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
}
