{pkgs}:
pkgs.writeShellApplication {
  name = "duo-display-niri";
  runtimeInputs = [pkgs.bash pkgs.niri];
  text = ''
    set -eu
    if [[ "$1" == "on" ]]; then
      niri msg output eDP-2 on
    elif [[ "$1" == "off" ]]; then
      niri msg output eDP-2 off
    fi  '';
}
