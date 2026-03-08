{
  flake.modules.nixos.waldo = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/22314ec0-dfb9-40b7-9423-75776f3a048e";
      fsType = "ext4";
    };
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/CA54-1DA2";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };
}
