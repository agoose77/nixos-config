# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./services
    ./disks.nix
    ./throttlestop.nix
    # Global config
    ../common/global.nix
    # User config
    ../common/users/angus
    # Optional config
    ../common/features/quiet-boot.nix
    ../common/features/power.nix
    ../common/features/bluetooth.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

  networking = {
    hostName = "hass";
    interfaces."eno2" = {
      macAddress = "20:47:47:79:c5:7d";
      wakeOnLan.enable = true;
    };
  };
  # Gnome fix?
  #  programs.ssh.startAgent = true;
  #  services.gnome.gcr-ssh-agent.enable = false;

  # Allow Caddy to user to manage and create certs
  services.tailscale.permitCertUid = "caddy";

  # Enable container toolkit
  hardware.nvidia-container-toolkit.enable = true;

  # Allow rootless to bind low numbered ports
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 0;
  };

  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "iHD";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; # Enable Wayland support for slack
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # For better video playback
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vaapiIntel
      intel-media-driver
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  environment.systemPackages = [
    pkgs.acpi
    pkgs.brightnessctl
  ];
  nixpkgs.config.nvidia.acceptLicense = true;
}
