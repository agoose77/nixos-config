{pkgs}: let
  idle-env = pkgs.python314.buildEnv.override {
    extraLibs = with pkgs.python314Packages; [
      paho-mqtt
    ];
    ignoreCollisions = false;
  };
in
  pkgs.writeShellApplication {
    name = "idle-monitor";
    runtimeInputs = [idle-env pkgs.wayidle];
    text = ''python3 ${./idle-monitor} "$@"'';
  }
