{lib, ...}: {
  flake.modules.nixos.waldo = {
    pkgs,
    modulesPath,
    ...
  }: {
    # FIXME: Fix for missing NPU option
    imports = [(modulesPath + "/hardware/cpu/intel-npu.nix")];
    boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    boot.initrd.luks.devices."luks-e9d523c6-75c0-4a2c-88f9-981e552b7519".device = "/dev/disk/by-uuid/e9d523c6-75c0-4a2c-88f9-981e552b7519";

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
    # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = "x86_64-linux";
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.cpu.intel.updateMicrocode = true;
    hardware.cpu.intel.npu.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      # For better video playback
      extraPackages = with pkgs; [
        vpl-gpu-rt
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };
}
