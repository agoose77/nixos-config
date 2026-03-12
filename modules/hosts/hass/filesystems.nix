{
  flake.modules.nixos.hass = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/6c63a40e-9581-4fa7-b50a-b7f583e8c27f";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/6228-13FD";
      fsType = "vfat";
    };
    fileSystems."/mnt/data" = {
      device = "/dev/disk/by-uuid/7028A53628A4FC6A";
      fsType = "ntfs";
      options = [
        # If you don't have this options attribute, it'll default to "defaults"
        # boot options for fstab. Search up fstab mount options you can use
        "users" # Allows any user to mount and unmount
        "nofail" # Prevent system from failing if this drive doesn't mount,
        "rw"
        "uid=1000"
        "gid=501"
      ];
    };
  };
}
