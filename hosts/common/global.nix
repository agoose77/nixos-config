# Basic configuration common to all hosts
{
  inputs,
  outputs,
  lib,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    ./features/autologin-angus.nix
    ./features/docker.nix
    ./features/sops.nix
    ./features/podman.nix
    ./features/openvpn.nix
    ./features/openssh.nix
    ./features/spotify-connect.nix
    ./features/sound.nix
    ./features/boot.nix
    ./features/tailscale.nix
    ./features/usb.nix
    ./features/1password.nix
    ./features/nix.nix
    ./features/kdeconnect.nix
    ./features/locale.nix
    ./features/flatpak.nix
    ./features/gnome-keyring.nix
    ./features/avahi.nix
    ./features/nix-ld.nix
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  system.stateVersion = "23.11";
  networking.networkmanager.enable = true;

  xdg.portal.enable = true;

  # Opt out of light-dm by default
  services.xserver.displayManager.lightdm.enable = lib.mkForce false;
  services.xserver.enable = true;
}
