{inputs, ...}: {
  flake.modules.nixos.hass = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-minimal
      systemd-boot
      throttlestop
      bluetooth
      power
      autologin-angus
      # services
      hass-mqtt
      hass-mosquitto
      hass-caddy
      hass-frigate
      hass-jellyfin
      hass-arr
      hass-home-assistant
      hass-speedtest
      hass-influx
    ];

    networking.hostName = "hass";

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
