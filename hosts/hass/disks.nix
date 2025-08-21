{
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
}
