{
  lib,
  pkgs,
  ...
}: {
  sops.templates."nixos-activity.json".file = let
    config = {
      password = "${config.sops.placeholder.activityPassword}";
      username = "${config.sops.placeholder.activityUser}";
      port = 1883;
      host = "hass.local";
      timeout = 300;
      interval = 30;
      tls = false;
      discoveryTopic = "homeassistant/binary_sensor/nixos/occupancy/config";
      stateTopic = "nixos/occupancy/state";
      name = "Occupancy";
      deviceArea = "Angus' Office";
      deviceName = "NixOS";
      deviceIds = [
        "nixos-idle-monitor"
      ];
    };
  in
    ((pkgs.formats.json {}).generate "nixos-activity.json" config).path;

  # Track activity
  systemd.user.services.report-activity = {
    description = "Report activity to MQTT server.";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
    };

    script = ''
      #!/usr/bin/env bash
      set -eu
      ${lib.getExe pkgs.idle-monitor} /etc/nixos-activity/config.json
    '';
  };
}
