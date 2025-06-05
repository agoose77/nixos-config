{
  lib,
  pkgs,
  ...
}: {
  programs.bash.profileExtra = lib.mkBefore ''
    if [[ "$(tty)" == /dev/tty1 ]]; then
      exec ${pkgs.hyprland} &> /dev/null
    fi
  '';
}
