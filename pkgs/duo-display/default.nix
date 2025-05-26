{pkgs}:
pkgs.writeShellApplication {
  name = "duo-display";
  runtimeInputs = [pkgs.bash pkgs.hyprland pkgs.jq];
  text = ''
    set -eu

    # needs jq, hyprctl
    export HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl instances -j | jq .[0].instance -r)

    if [[ "$1" == "both" ]]; then
      hyprctl keyword monitor "eDP-2,1920x1200@60,auto-down,1"
    elif [[ "$1" == "top" ]]; then
      hyprctl keyword monitor "eDP-2, disable"
    fi  '';
}
