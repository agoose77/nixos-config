{pkgs, ...}: {
  boot.kernelModules = ["intel_vpu"];
  boot.lanzaboote.configurationLimit = 1;
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
  services.hardware.bolt.enable = true;

  hardware.sensor.iio.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
}
