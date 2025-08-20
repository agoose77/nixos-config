# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    # Host specific config
    ./services.nix
    # Optional config
    ../common/features/quiet-boot.nix
    ../common/features/podman.nix
    ../common/features/boot.nix
    ../common/features/tailscale.nix
    ../common/features/nix.nix
    ../common/features/locale.nix
    ../common/features/openssh.nix
    ../common/features/sound.nix
    ../common/features/avahi.nix
    ../common/features/usb.nix
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays."home-assistant"
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alejandra
    git
    curl
    neovim
  ];
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };
  networking = {
    hostName = "home-assistant";
    networkmanager.enable = true;
    interfaces."enp4s0".macAddress = "20:47:47:79:c5:7d";
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    angus = {
      isNormalUser = true;
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["networkmanager" "wheel" "media"];
      packages = with pkgs; [];
      shell = pkgs.bash;
      uid = 1000;
    };
  };
  # Choose group ID for media
  users.groups.media.gid = 501;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

  programs.ssh.startAgent = true;
  services.gnome.gcr-ssh-agent.enable = false;

  # Allow Caddy to user to manage and create certs
  services.tailscale.permitCertUid = "caddy";

  hardware.graphics = {
    enable = true;
    # For better video playback
    extraPackages = with pkgs; [nvidia-vaapi-driver];
  }; 

  hardware.coral.usb.enable = true;

  # Allow rootless to bind low numbered ports
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 0;
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
}
