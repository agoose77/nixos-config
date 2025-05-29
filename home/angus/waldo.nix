{pkgs, ...}: {
  imports = [./global];
  home.packages = [
    pkgs.luminance
    pkgs.brightnessctl
  ];
  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1200;
      workspace = "1";
      primary = true;
    }
    {
      name = "eDP-2";
      width = 1920;
      height = 1200;
      position = "auto-down";
      workspace = "2";
    }
  ];

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

  wayland.windowManager.hyprland.settings."exec-once" = [
    "${pkgs.wvkbd}/bin/wvkbd-mobintl -H 200 -L 300 --hidden"
  ];
}
