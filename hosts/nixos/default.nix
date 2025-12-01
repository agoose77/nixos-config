# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    # Global config
    ../common/global.nix
    # User config
    ../common/users/angus
    # Optional config
    ../common/features/quiet-boot.nix
    ../common/features/k3s.nix
    ../common/features/hyprland.nix
    ../common/features/hyprlock.nix
  ];

  networking = {
    hostName = "nixos";
    # Enable wake on LAN
    interfaces.enp4s0.wakeOnLan.enable = true;
  };

  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; # Enable Wayland support for slack
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # For better video playback
    extraPackages = with pkgs; [nvidia-vaapi-driver];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Mouse
  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["angus"];

  # Track activity
  systemd.user.services.report-activity = {
    description = "Report activity to MQTT server.";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
    };

    script = ''
      #!/usr/bin/env bash
      set -eu
      ${lib.getExe pkgs.idle-monitor} /etc/nixos-activity/config.json
    '';
  };
}
