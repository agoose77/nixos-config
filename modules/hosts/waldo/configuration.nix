{inputs, ...}: {
  flake.modules.nixos.waldo = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-default
      secure-boot
      bluetooth
      zenbook-display
      power
      wvkbd
      autologin-angus
    ];
    boot.lanzaboote.configurationLimit = 2;

    networking.hostName = "waldo";

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1"; # Enable Wayland support for slack
    };

    environment.systemPackages = [
      pkgs.acpi
      # For pulling Bluetooth keys from Windows
      pkgs.chntpw
      pkgs.dislocker
    ];

    services.hardware.bolt.enable = true;
    services.zenbook-display = {
      enable = true;
      package = pkgs.local.duo-display-niri;
    };
  };
  flake.modules.homeManager.waldo = {pkgs, ...}: {
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
