{inputs, ...}: {
  flake.modules.nixos.waldo = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-default
      secure-boot
      bluetooth
    ];
    boot.kernelModules = ["intel_vpu"];
    boot.lanzaboote.configurationLimit = 1;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      # For better video playback
      extraPackages = with pkgs; [
        vpl-gpu-rt
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
    services.hardware.bolt.enable = true;

    swapDevices = [
      {
        device = "/swapfile";
        size = 16 * 1024; # 16GB
      }
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
