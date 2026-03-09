{pkgs}:
pkgs.writeShellApplication {
  name = "duo-display-hyprland";
  runtimeInputs = [pkgs.bash pkgs.hyprland pkgs.jq];
  text = ''
    set -eu

    # needs jq, hyprctl
    HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl instances -j | jq .[0].instance -r)
    export HYPRLAND_INSTANCE_SIGNATURE

    if [[ "$1" == "on" ]]; then
      hyprctl keyword monitor "eDP-2,1920x1200@60,auto-down,1"
    elif [[ "$1" == "off" ]]; then
      hyprctl keyword monitor "eDP-2, disable"
    fi  '';
}
