{
  flake.modules.nixos.nixos = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/916b121a-17e1-4c77-835e-3c60c43ac84b";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/048C-1BE9";
      fsType = "vfat";
    };
  };
}
