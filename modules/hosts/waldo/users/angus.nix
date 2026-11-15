{inputs, ...}: {
  flake.modules.nixos.waldo = {config, ...}: {
    imports = with inputs.self.modules.nixos; [
      angus
    ];

    # ...

    home-manager.users.angus = {
      pkgs,
      lib,
      ...
    }: {
      imports = with inputs.self.modules.homeManager; [system-desktop];

      home.packages = [
        pkgs.luminance
        pkgs.brightnessctl
      ];

      wayland.windowManager.niri.settings = {
        input = {
          touch.map-to-output = "eDP-1";
          tablet.map-to-output = "eDP-2";
        };
        _children = [
          {
            output = {
              _args = ["eDP-1"];
              scale = 1;
              mode = "1920x1200";
              focus-at-startup = {};
              position._props = {
                x = 0;
                y = 0;
              };
            };
          }
          {
            output = {
              _args = ["eDP-2"];
              scale = 1;
              mode = "1920x1200";
              position._props = {
                x = 0;
                y = 1200;
              };
            };
          }
        ];
      };

      programs.noctalia.settings = {
        bar.default.start = ["launcher" "wallpaper" "workspaces" "custom/kbd" "mirror"];
        widget."custom/kbd" = {
          type = "custom_button";
          glyph = "keyboard-show";
          actions = let
            cmd = pkgs.writeShellScript "toggle-keyboard.sh" ''
              ${pkgs.procps}/bin/pkill -SIGRTMIN -x wvkbd-mobintl
            '';
          in {
            left = "exec ${cmd}";
          };
        };
        widget.mirror = {
          type = "elijaharch/wl-screen-mirror:mirror";
        };
      };
    };
  };
}
