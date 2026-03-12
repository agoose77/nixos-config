{flake.modules.nixos.hass-mqtt = {pkgs, ...}: {
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
};}
