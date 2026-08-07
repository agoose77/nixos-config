{
  flake.modules.nixos.hass-mosquitto = {
    lib,
    pkgs,
    ...
  }: let
    configFile = pkgs.writeTextFile {
      name = "mosquitto.conf";
      text = ''
        allow_anonymous false
        listener 1883
        listener 9001
        protocol websockets
        persistence true
        password_file /mosquitto/config/pwfile
        persistence_file mosquitto.db
        persistence_location /mosquitto/data/
      '';
    };
    network = "mqtt-bridge";
    pwFile = pkgs.writeTextFile {
      name = "pwfile";
      text = ''root:$7$101$TogZKXwkPsXXDZvE$rBRp2ORyuWGrNH5DY1QJa6+eqNwDKt0185e99TYW6p7oKksyRX/E13jEJGWO2BoUys1vSMETJXP/YIFDKiF6Eg=='';
    };
  in {
    virtualisation.oci-containers.containers.mosquitto = {
      ports = [
        "1883:1883"
        "9001:9001"
      ];
      image = "docker.io/eclipse-mosquitto:2.0.22";
      volumes = [
        "${configFile}:/mosquitto/config/mosquitto.conf"
        "${pwFile}:/mosquitto/config/pwfile"
      ];
      extraOptions = [
        "--network=${network}"
      ];
    };

    systemd.services.init-mqtt-network = {
      description = "Create the network bridge for mqtt.";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "oneshot";
      script = ''
        if ! ${lib.getExe pkgs.podman} network exists ${network}; then
          ${lib.getExe pkgs.podman} network create ${network}
        else
          echo "${network} already exists"
        fi
      '';
    };
  };
}
