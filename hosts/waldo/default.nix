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
    ../common/features/secure-boot.nix
    ../common/features/quiet-boot.nix
    ../common/features/power.nix
    ../common/features/bluetooth.nix
    # Host-specific config
    ./displays.nix
  ];

  networking.hostName = "waldo";

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; # Enable Wayland support for slack
  };

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

  hardware.sensor.iio.enable = true;

  environment.systemPackages = [
    pkgs.acpi
    pkgs.brightnessctl
    pkgs.duo-display
    # For pulling Bluetooth keys from Windows
    pkgs.chntpw
    pkgs.dislocker
  ];

  services.hardware.bolt.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
}
