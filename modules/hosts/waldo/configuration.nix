{inputs, ...}: {
  flake.modules.nixos.waldo = {
    imports = with inputs.self.modules.nixos; [
      system-default
      secure-boot
      bluetooth
    ];
  };
  flake.modules.homeManager.niri = {
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
  };
}
