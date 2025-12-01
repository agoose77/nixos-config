{
  pkgs,
  ...
}: {
  programs.niri.enable = true;
  security.polkit.enable = true; # polkit
  # XWayland
  environment.systemPackages = [pkgs.xwayland-satellite];

  # Configure UWSM to launch Niri from a display manager like SDDM
  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors = {
    niri = {
      prettyName = "Niri";
      comment = "Niri compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/niri-session";
    };
  };
}
