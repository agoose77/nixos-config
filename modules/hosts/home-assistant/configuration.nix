{
  inputs,
  ...
}: {
  flake.modules.nixos.home-assistant = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-minimal
      systemd-boot
      throttlestop
      bluetooth
      power
      auto-upgrade
      # services
      home-assistant-mosquitto
      home-assistant-caddy
      home-assistant-frigate
      home-assistant-jellyfin
      home-assistant-arr
      home-assistant-home-assistant
      home-assistant-influx
      home-assistant-esphome
    ];

    networking.hostName = "home-assistant";

    environment.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "iHD";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1"; # Enable Wayland support for slack
    };

    services.hardware.bolt.enable = true;
  };
}
