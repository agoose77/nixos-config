{lib, ...}: {
  flake.modules.nixos.hass = {
    pkgs,
    modulesPath,
    config,
    ...
  }: {
    # FIXME: Fix for missing NPU option
    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];

    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    boot.initrd.luks.devices."luks-e9d523c6-75c0-4a2c-88f9-981e552b7519".device = "/dev/disk/by-uuid/e9d523c6-75c0-4a2c-88f9-981e552b7519";

    networking = {
      hostName = "hass";
      useDHCP = lib.mkDefault true;
      interfaces."eno2" = {
        macAddress = "20:47:47:79:c5:7d";
        wakeOnLan.enable = true;
      };
    };

    swapDevices = [
      {
        device = "/swapfile";
        size = 16 * 1024; # 16GB
      }
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.cpu.intel.updateMicrocode = true;

    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      # For better video playback
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        intel-vaapi-driver
        intel-media-driver
      ];
    };

    nixpkgs.config.nvidia.acceptLicense = true;
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
    # Enable container toolkit
    hardware.nvidia-container-toolkit.enable = true;

    # Allow rootless to bind low numbered ports
    boot.kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 0;
    };
  };
}
