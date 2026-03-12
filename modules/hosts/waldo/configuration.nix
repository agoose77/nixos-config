{inputs, ...}: {
  flake.modules.nixos.waldo = {pkgs, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-default
      secure-boot
      bluetooth
      zenbook-display
      power
      wvkbd
      autologin-angus
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

    services.hardware.bolt.enable = true;
    services.zenbook-display = {
      enable = true;
      package = pkgs.local.duo-display-niri;
    };
  };
}
