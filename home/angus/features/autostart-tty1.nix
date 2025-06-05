{
  lib,
  pkgs,
  ...
}: {
  programs.bash.profileExtra = lib.mkBefore ''
       if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
    fi  '';
}
