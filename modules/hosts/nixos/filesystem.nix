{
  flake.modules.nixos.nixos = {
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d8e8d33a-5714-4389-bb94-06a66895cfd8";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/44D5-59F2";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  swapDevices =
    [ { device = "/dev/disk/by-uuid/0ccc62b9-8bcf-463e-8a20-844161ca017e"; }
  ];
  };

}
