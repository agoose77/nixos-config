{pkgs, ...}: {
  # Disable eDP-2 when keyboard plugged in
  systemd.user.services.respond-to-keyboard = {
    description = "Switch displays as keyboard is removed.";
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
    script = ''
      #!/usr/bin/env bash
      while ${pkgs.inotify-tools}/bin/inotifywait -e attrib /dev/bus/usb/*/; do
      if ${pkgs.usbutils}/bin/lsusb -d 0b05:1b2c; then
      ${pkgs.hyprland}/bin/hyprctl keyword monitor "eDP-2,disable"
      else
      ${pkgs.hyprland}/bin/hyprctl keyword monitor "eDP-2,1920x1200@60,auto-down,1"
      fi
      done
    '';
  };
}
