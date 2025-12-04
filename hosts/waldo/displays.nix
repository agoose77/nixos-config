{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.acpi
    pkgs.brightnessctl
    pkgs.duo-display
    # For pulling Bluetooth keys from Windows
    pkgs.chntpw
    pkgs.dislocker
  ];
  services.zenbook-display = {
    enable = true;
    package = pkgs.duo-display;
  };
}
