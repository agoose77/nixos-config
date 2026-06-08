{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.waldo = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-default
      secure-boot
      bluetooth
      power
      wvkbd
      autologin-angus
      zenbook-duo-daemon
    ];
    boot.lanzaboote.configurationLimit = 2;

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

    # In your NixOS configuration module
    services.zenbook-duo-daemon = {
      enable = true;
      touchpad.enable = false;

      # Key mappings examples:
      keyMappings = {
        # Example 3: Remap a key to different keybinds
        # This makes brightness up send Super+Up instead
        brightnessUp = {
          type = "KeyBind";
          keys = ["KEY_LEFTCTRL" "KEY_LEFTSHIFT" "KEY_UP"];
        };
        # Example 3: Remap a key to different keybinds
        # This makes brightness up send Super+Up instead
        brightnessDown = {
          type = "KeyBind";
          keys = ["KEY_LEFTCTRL" "KEY_LEFTSHIFT" "KEY_DOWN"];
        };
      };

      # All keybinds and settings are configurable via Nix options
    };
    services.hardware.bolt.enable = true;
  };
}
