{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./features/niri.nix
    ./global.nix
  ];
  home.packages = [
    pkgs.luminance
    pkgs.brightnessctl
  ];

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1200;
      primary = true;
      position = {
        x = 0;
        y = 0;
      };
    }
    {
      name = "eDP-2";
      width = 1920;
      height = 1200;
      position = {
        x = 0;
        y = 1200;
      };
    }
  ];

  # Touch keyboard
  programs.waybar.settings.primary = {
    modules-right = ["custom/kbd"];
    "custom/kbd" = {
      interval = "once";
      exec = "${pkgs.coreutils}/bin/echo a";
      exec-if = "${pkgs.coreutils}/bin/true";
      format = " 󰌌   ";
      on-click = pkgs.writeShellScript "toggle-keyboard.sh" ''
        ${pkgs.procps}/bin/pkill -SIGRTMIN -x wvkbd-mobintl
      '';
    };
  };
}
