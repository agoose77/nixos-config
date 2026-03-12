{inputs, ...}: {
  flake.modules.nixos.nixos = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-default
      systemd-boot
      autologin-angus
      k3s
      nixos-activity
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
}
