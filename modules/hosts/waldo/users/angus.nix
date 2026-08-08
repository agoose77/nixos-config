{inputs, ...}: {
  flake.modules.nixos.waldo = {config, ...}: {
    imports = with inputs.self.modules.nixos; [
      angus
    ];

    # ...

    home-manager.users.angus = {pkgs, ...}: {
      imports = with inputs.self.modules.homeManager; [system-default];
      home.packages = [
        pkgs.luminance
        pkgs.brightnessctl
      ];
      programs.niri.settings = {
        input = {
          touch.map-to-output = "eDP-1";
          tablet.map-to-output = "eDP-2";
        };
        outputs."eDP-1" = {
          scale = 1;
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
          scale = 1;
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

      programs.noctalia.settings = {
        bar.default.start = ["custom/kbd"];
        widget.quick-action = {
          type = "custom_button";
          glyph = "keyboard-show";
          label = "Action";
          actions = let
            cmd = pkgs.writeShellScript "toggle-keyboard.sh" ''
              ${pkgs.procps}/bin/pkill -SIGRTMIN -x wvkbd-mobintl
            '';
          in {
            left = "exec ${cmd}";
            right = "exec notify-send 'Other action'";
          };
        };
      };
    };
  };
}
