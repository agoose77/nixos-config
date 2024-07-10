# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/global
    ../common/users/angus
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  networking.hostName = "latitude";

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
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  environment.systemPackages = [pkgs.nvidia-offload];
  nixpkgs.config.nvidia.acceptLicense = true;

  # Battery management
  services.tlp.enable = true;
  powerManagement.enable = true;
}
