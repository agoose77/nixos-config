{
  lib,
  pkgs,
  ...
}: {
  # Track activity
  systemd.user.services.onscreen-keyboard = {
    description = "Start on-screen kbd widget.";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
    };
    script = ''
      ${lib.getExe' pkgs.wvkbd "wvkbd-mobintl"} -H 200 -L 300 --hidden
    '';
  };
}
