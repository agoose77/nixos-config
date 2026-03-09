{lib, ...}: {
  flake.modules.nixos.nixos = {
    pkgs,
    modulesPath,
    config,
    ...
  }: {
    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    swapDevices = [
      {
        device = "/swapfile";
        size = 16 * 1024; # 16GB
      }
    ]; # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    networking .interfaces.enp4s0.wakeOnLan.enable = true;

    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.cpu.amd.updateMicrocode = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      # For better video playback
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };

    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # Mouse
    hardware.openrazer.enable = true;
    hardware.openrazer.users = ["angus"];
  };
}
