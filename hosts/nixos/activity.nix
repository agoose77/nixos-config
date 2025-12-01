{
  lib,
  pkgs,
  ...
}: {
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
