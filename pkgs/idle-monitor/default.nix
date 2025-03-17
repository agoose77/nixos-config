{pkgs}: let
  idle-env = pkgs.python312.buildEnv.override {
    extraLibs = with pkgs.python312Packages; [
      paho-mqtt
    ];
    ignoreCollisions = false;
  };
in
  pkgs.writeShellApplication {
    name = "idle-monitor";
    runtimeInputs = [idle-env];
    text = ''python3 ${./idle-monitor} "$@"'';
  }
