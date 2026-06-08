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
      zenbook-display
      power
      wvkbd
      autologin-angus

      inputs.zenbook-duo-daemon.nixosModules.default
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
    services.zenbook-duo-daemon = let
      stepBrightness = name: delta:
        lib.getExe (pkgs.writeShellApplication {
          name = "brightness-${name}";
          runtimeInputs = [pkgs.brightnessctl pkgs.coreutils pkgs.findutils];
          text = ''
            brightnessctl -c backlight -l -m | cut -d ',' -f1 | xargs -L1 echo @@ brightnessctl s ${delta} -d @@
            brightnessctl -c backlight -l -m | cut -d ',' -f1 | xargs -L1 brightnessctl s '${delta}' -d
          '';
        });
    in {
      enable = true;
      package = inputs.zenbook-duo-daemon.packages.x86_64-linux.default;
      touchpad = {
        brightnessIncrementCommand =
          stepBrightness "up" "5%+";
        brightnessDecrementCommand =
          stepBrightness "down" "5%-";
      };

      # All keybinds and settings are configurable via Nix options
    };
    systemd.services.zenbook-duo-daemon.serviceConfig.Environment = lib.mkForce "RUST_LOG=debug";
    services.hardware.bolt.enable = true;
    services.zenbook-display = {
      enable = false;
      package = pkgs.local.duo-display-niri;
    };
  };
}
