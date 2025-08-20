# Basic configuration common to all hosts
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
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    ./podman.nix
    ./openvpn.nix
    ./openssh.nix
    ./spotify-connect.nix
    ./sound.nix
    ./boot.nix
    ./tailscale.nix
    ./usb.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./1password.nix
    ./k3s.nix
    ./nix.nix
    ./kdeconnect.nix
    ./locale.nix
    ./flatpak.nix
    ./gnome-keyring.nix
    ./avahi.nix
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

  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  networking.networkmanager.enable = true;

  xdg.portal.enable = true;

  # Opt out of light-dm by default
  services.xserver.displayManager.lightdm.enable = lib.mkForce false;
  services.xserver.enable = true;
}
