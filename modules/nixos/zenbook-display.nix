{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.zenbook-display;
in {
  options.services.zenbook-display = {
    enable = mkEnableOption (lib.mdDoc "ASUS Zebook Display");

    package = mkOption {
      type = types.package;
      default = null;
      description = lib.mdDoc ''
        The display controller package to use.
        Accepts a single $1 argument on/off to toggle displays.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Disable eDP-2 when keyboard plugged in
    systemd.user.services.respond-to-keyboard = {
      description = "Switch displays as keyboard is removed.";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
      };

      script = ''
        function update_displays() {
            if ${lib.getExe' pkgs.usbutils "lsusb"} -d 0b05:1b2c; then
                ${lib.getExe cfg.package} top
            else
                ${lib.getExe cfg.package} both
            fi
        }

        update_displays
        while ${lib.getExe' pkgs.inotify-tools "inotifywait"} -e attrib /dev/bus/usb/*/; do
            update_displays
        done

      '';
    };
  };
}
