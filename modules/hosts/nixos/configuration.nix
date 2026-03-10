{inputs, ...}: {
  flake.modules.nixos.nixos = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-default
      systemd-boot
      autologin-angus
      k3s
    ];

    networking.hostName = "nixos";

    environment.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1"; # Enable Wayland support for slack
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
  flake.modules.homeManager.nixos = {pkgs, ...}: {
    home.packages = [
      pkgs.luminance
      pkgs.brightnessctl
    ];
    programs.niri.settings = {
      outputs."eDP-1" = {
        mode = {
          width = 1920;
          height = 1200;
        };
        focus-at-startup = true;
        position = {
          x = 0;
          y = 0;
        };
      };
      outputs."eDP-2" = {
        mode = {
          width = 1920;
          height = 1200;
        };
        position = {
          x = 0;
          y = 1200;
        };
      };
    };

    # Touch keyboard
    programs.waybar.settings.primary = {
      modules-right = ["custom/kbd"];
      "custom/kbd" = {
        interval = "once";
        exec = "${pkgs.coreutils}/bin/echo a";
        exec-if = "${pkgs.coreutils}/bin/true";
        format = " <U+F030C>   ";
        on-click = pkgs.writeShellScript "toggle-keyboard.sh" ''
          ${pkgs.procps}/bin/pkill -SIGRTMIN -x wvkbd-mobintl
        '';
      };
    };
  };
}
