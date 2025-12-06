# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{pkgs, ...}: {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./custom-hardware-configuration.nix
    # Global config
    ../common/global.nix
    # User config
    ../common/users/angus
    # Optional config
    ../common/features/secure-boot.nix
    ../common/features/quiet-boot.nix
    ../common/features/power.nix
    ../common/features/bluetooth.nix
    ../common/features/niri.nix
    ../common/features/wvkbd.nix
    # Host-specific config
    ./displays.nix
  ];

  networking.hostName = "waldo";

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; # Enable Wayland support for slack
  };

  environment.systemPackages = [
    pkgs.acpi
    # For pulling Bluetooth keys from Windows
    pkgs.chntpw
    pkgs.dislocker
  ];
}
