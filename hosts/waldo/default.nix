# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common/global
    ../common/users/angus
    ../common/optional/secure-boot.nix
    ../common/optional/quiet-boot.nix
    ../common/optional/power.nix
    ../common/optional/bluetooth.nix
    ./displays.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  networking.hostName = "waldo";

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; # Enable Wayland support for slack
  };

  boot.kernelModules = ["intel_vpu"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # For better video playback
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
      vaapiIntel
      vaapiVdpau
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
