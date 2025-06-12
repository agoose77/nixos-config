{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 5;
        hide_cursor = true;
      };
      animations = {
        enabled = true;
        bezier = [
          "easeout,0.5, 1, 0.9, 1"
          "easeoutback,0.34,1.22,0.65,1"
        ];
        animation = [
          "fade, 1, 3, easeout"
          "inputField, 1, 1, easeoutback"
        ];
      };
      background = {
        path = "screenshot";
        blur_passes = 4;
      };
      input-field = {
        position = "0, 20%";
        halign = "center";
        valign = "bottom";

        # Hide outline and filling
        outline_thickness = 0;
        inner_color = "rgba(00000000)";
        check_color = "rgba(00000000)";
        fail_color = "rgba(00000000)";
      };
      label = {
        text = "$TIME";
        font_size = "180";

        position = "0 0";
        halign = "center";
        valign = "center";
      };
    };
  };
  wayland.windowManager.hyprland.settings."exec-once" = lib.mkBefore [
    "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.hyprlock}/bin/hyprlock --immediate"
  ];
}
