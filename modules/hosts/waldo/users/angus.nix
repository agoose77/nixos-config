{inputs, ...}: {
  flake.modules.nixos.waldo = {config, ...}: {
    imports = with inputs.self.modules.nixos; [
      angus
    ];

    # ...

    home-manager.users.angus = {pkgs, ...}: {
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
  };
}
