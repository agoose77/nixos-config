{
  pkgs,
  lib,
  ...
}: {
  # Track activity
  systemd.services.throttlestop = {
    description = "Update CPU temperature and voltage targets.";
    wantedBy = ["multiuser.target"];
    after = ["multiuser.target"];
    serviceConfig = {
    Type = "simple";
      Restart = "always";
      RuntimeMaxSec = "30m";
    };
    script = ''
      #!/usr/bin/env bash
      set -eu
      ${lib.getExe pkgs.throttlestop} temperature "{\"offset\": 20}"
      ${lib.getExe pkgs.throttlestop} voltage "{\"cache\": -149, \"cpu\": -149}"
    '';
  };
}
